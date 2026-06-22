Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();

[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'

function Show-Console
{
    $consolePtr = [Console.Window]::GetConsoleWindow()

    # Hide = 0,
    # ShowNormal = 1,
    # ShowMinimized = 2,
    # ShowMaximized = 3,
    # Maximize = 3,
    # ShowNormalNoActivate = 4,
    # Show = 5,
    # Minimize = 6,
    # ShowMinNoActivate = 7,
    # ShowNoActivate = 8,
    # Restore = 9,
    # ShowDefault = 10,
    # ForceMinimized = 11

    [Console.Window]::ShowWindow($consolePtr, 4)
}

function Hide-Console
{
    $consolePtr = [Console.Window]::GetConsoleWindow()
    #0 hide
    [Console.Window]::ShowWindow($consolePtr, 0)
}


Hide-Console | Out-Null

# =========================
# CONFIG
# =========================

# Force STA (required for dialogs)
if ([System.Threading.Thread]::CurrentThread.ApartmentState -ne 'STA') {
    Write-Host "Run this script in STA mode: powershell -STA"
    exit
}

# Folder selection dialog
$folderDialog = New-Object System.Windows.Forms.FolderBrowserDialog
$folderDialog.Description = "Select folder to save output files"
$folderDialog.ShowNewFolderButton = $true

$result = $folderDialog.ShowDialog()

# Cancel handling
if ($result -ne [System.Windows.Forms.DialogResult]::OK) {
    Write-Host "No folder selected. Exiting..."
    exit
}

# Store selected folder globally
$script:SaveFolder = $folderDialog.SelectedPath
$script:ffmpegProcess = $null

# =========================
# GET CAMERA LIST
# =========================
$ffmpegPath = "C:\Temp\ffmpeg\bin\ffmpeg.exe"
$deviceList = & $ffmpegPath -list_devices true -f dshow -i dummy 2>&1

$cameras = @()

for ($i = 0; $i -lt $deviceList.Count; $i++) {

    # ALT NAME is every 2nd line (odd index)
    if ($i % 2 -eq 1) {

        $alt = $deviceList[$i]

        # only keep real PnP devices
        if ($alt -match '@device_pnp_') {

            # friendly name is previous line
            $friendly = $deviceList[$i - 1]

            # clean friendly name (remove quotes / junk)
            $friendly = ($friendly -replace '[^\w\s\-]', '') -replace '^in0\s+\S+\s+', ''

            $cameras += [PSCustomObject]@{
                FriendlyName = $friendly.Trim() 
                AltName      = ($alt -replace '.*?"(.*?)".*','$1')
            }
        }
    }
}
  

# =========================
# FORM
# =========================

[System.Windows.Forms.Application]::EnableVisualStyles()

$form = New-Object System.Windows.Forms.Form
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false
$form.Text = "    FFmpeg Webcam Recorder"
$form.Size = New-Object System.Drawing.Size(465,180)
$form.StartPosition = "CenterScreen"

# Dropdown
$combo = New-Object System.Windows.Forms.ComboBox
$combo.Location = New-Object System.Drawing.Point(10,20)
$combo.Width = 430
$cameras.FriendlyName | ForEach-Object { [void]$combo.Items.Add($_) }
$combo.SelectedIndex = 0
$form.Controls.Add($combo)

# Start button
$btnStart = New-Object System.Windows.Forms.Button
$btnStart.Text = "Start Recording"
$btnStart.Location = New-Object System.Drawing.Point(20,70)
$btnStart.Width = 200
$form.Controls.Add($btnStart)

# Stop button
$btnStop = New-Object System.Windows.Forms.Button
$btnStop.Text = "Stop Recording"
$btnStop.Location = New-Object System.Drawing.Point(230,70)
$btnStop.Width = 200
$btnStop.Enabled = $false
$form.Controls.Add($btnStop)

# Status label
$label = New-Object System.Windows.Forms.Label
$label.Text = "Ready"
$label.Location = New-Object System.Drawing.Point(20,120)
$label.Width = 400
$form.Controls.Add($label)
# =========================
#    OPEN FORMS WINDOW
# =========================



# =========================
# START RECORDING
# =========================
$btnStart.Add_Click({
    $cameraName = ($cameras | Where-Object { $_ -match $combo.SelectedItem }).AltName

    $label.Text = "Recording..."

    $SaveOutput = Recorded-Output

    $args = @(
    "-f", "dshow",
    "-i", "video=$cameraName",
    "-vcodec", "libx264",
    "-preset", "0",
    "-pix_fmt", "yuv420p",
    "`"$SaveOutput`""
    )

    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = $ffmpegPath
    $psi.Arguments = $args
    $psi.UseShellExecute = $false
    $psi.RedirectStandardInput = $true
    $psi.RedirectStandardOutput = $false
    $psi.RedirectStandardError = $false
    $psi.CreateNoWindow = $true

    $script:ffmpegProcess = New-Object System.Diagnostics.Process
    $script:ffmpegProcess.StartInfo = $psi
    $script:ffmpegProcess.Start() | Out-Null

    $btnStart.Enabled = $false
    $btnStop.Enabled = $true
})

# =========================
# STOP RECORDING
$btnStop.Add_Click({

    if ($script:ffmpegProcess -and -not $script:ffmpegProcess.HasExited) {
        $script:ffmpegProcess.StandardInput.WriteLine("q")
        Start-Sleep -Milliseconds 500
    }

    if ($script:ffmpegProcess -and -not $script:ffmpegProcess.HasExited) {
        $script:ffmpegProcess.Kill()
    }

    $script:ffmpegProcess = $null

    $label.Text = "Saved to $script:SaveFolder"

    $btnStart.Enabled = $true
    $btnStop.Enabled = $false
})

# =========================
# CLOSE CLEANUP
# =========================
$form.Add_FormClosing({
   
    if((Get-Process -Name ffmpeg -ErrorAction SilentlyContinue)){
    (Get-Process -Name ffmpeg).Kill()
    }

})

function Recorded-Output {

$FileTime = ((Get-Date -Format o) -replace '[:,.]',"").ToString()
$FileName = "webcam_record_$FileTime.mp4"
$outputFile = Join-Path $script:SaveFolder $FileName

$outputFile

}


# =========================
# RUN
# =========================
$form.Focus()
$form.BringToFront()
[System.Windows.Forms.Application]::Run($form)

