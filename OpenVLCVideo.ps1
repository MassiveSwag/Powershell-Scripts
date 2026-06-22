<# 
    .NAME
        OpenVLCVideo
    
    .DESCRIPTION
        Opens video in VLC with Fullscreen, Repeat and Muted Sound. You can choose which directory the application uses for finding your videos.

    .ARTHOR
        Richard Rhodes
#>

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

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

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = New-Object System.Drawing.Point(400,380)
$Form.MinimizeBox                = $true
$Form.MaximizeBox                = $false
$Form.MainMenuStrip              = $FormMenu
$Form.text                       = " VLC Video Launcher"
$Form.FormBorderStyle            = "FixedDialog"
$Form.StartPosition              = "CenterScreen"
$Form.BringToFront()

$FormMenu                        = New-Object System.Windows.Forms.MenuStrip

$FormMenuItem                    = New-Object System.Windows.Forms.ToolStripMenuItem("File")

$FormMenuFolder                  = New-Object System.Windows.Forms.ToolStripMenuItem("Open Folder")
$FormMenuPlay                    = New-Object System.Windows.Forms.ToolStripMenuItem("Play Video")
$FormMenuExit                    = New-Object System.Windows.Forms.ToolStripMenuItem("Exit")



$FormMenuItem.DropDownItems.Add($FormMenuFolder) | Out-Null
$FormMenuItem.DropDownItems.Add($FormMenuPlay) | Out-Null
$FormMenuItem.DropDownItems.Add($FormMenuExit) | Out-Null

$FormMenu.Items.Add($FormMenuItem) | Out-Null


## Label
$Label                           = New-Object System.Windows.Forms.Label
$Label.Text                      = "Directory"
$Label.Width                     = 100
$Label.Height                    = 20
$Label.Font = New-Object System.Drawing.Font($Label.Font.FontFamily, 8, [System.Drawing.FontStyle]::Bold)
$Label.Location                  = New-Object System.Drawing.Point(2,28)

## Button
$Button                          = New-Object System.Windows.Forms.Button
$Button.Text                     = "Play Video"
$Button.Width                    = 100 
$Button.Height                   = 25
$Button.Location                 = New-Object System.Drawing.Point(2,330)

$Button1                          = New-Object System.Windows.Forms.Button
$Button1.Text                     = "Load Directory"
$Button1.Width                    = 100 
$Button1.Height                   = 25
$Button1.Location                 = New-Object System.Drawing.Point(298,330)

## Textbox
$TextBox1                       = New-Object System.Windows.Forms.TextBox
$TextBox1.Width                 = 342
$TextBox1.Height                = 20
$TextBox1.BorderStyle   = "FixedSingle"
$TextBox1.Multiline             = $false
$TextBox1.AutoCompleteMode = "SuggestAppend"
$TextBox1.AutoCompleteSource = "AllSystemSources"
$TextBox1.Location              = New-Object System.Drawing.Point(55,25)


## CheckBox
$CheckBox1                      = New-Object System.Windows.Forms.CheckBox
$CheckBox1.Text                 = "Sound Muted"
$CheckBox1.Height               = 13
$CheckBox1.Checked = $true
$CheckBox1.Location             = New-Object System.Drawing.Point(107,328)

$CheckBox2                      = New-Object System.Windows.Forms.CheckBox
$CheckBox2.Text                 = "Full Screen"
$CheckBox2.Height                = 13
$CheckBox2.Checked = $true
$CheckBox2.Location             = New-Object System.Drawing.Point(107,344)

$CheckBox3                      = New-Object System.Windows.Forms.CheckBox
$CheckBox3.Text                 = "Repeat"
$CheckBox3.Height                = 13
$CheckBox3.Checked = $true
$CheckBox3.Location             = New-Object System.Drawing.Point(107,360)

## Datagrid
$DataGridView1                   = New-Object System.Windows.Forms.DataGridView
$DataGridView1.width             = 396
$DataGridView1.height            = 275
$DataGridView1.MultiSelect = $false
$DataGridView1.EnableHeadersVisualStyles = $false
$DataGridView1.ForeColor = [System.Drawing.Color]::Black
$DataGridView1.AlternatingRowsDefaultCellStyle.BackColor = [System.Drawing.Color]::WhiteSmoke
$DataGridView1.AlternatingRowsDefaultCellStyle.ForeColor = [System.Drawing.Color]::Black
$DataGridView1.ColumnHeadersDefaultCellStyle.Font = New-Object System.Drawing.Font("segoe ui",12,[System.Drawing.FontStyle]::Bold) 
$DataGridView1.ColumnHeadersDefaultCellStyle.Alignment = [System.Windows.Forms.DataGridViewContentAlignment]::MiddleCenter
$DataGridView1.ColumnHeadersDefaultCellStyle.BackColor = [System.Drawing.Color]::DodgerBlue
$DataGridView1.ColumnHeadersDefaultCellStyle.SelectionBackColor = [System.Drawing.Color]::DodgerBlue
$DataGridView1.ColumnHeadersDefaultCellStyle.ForeColor = [System.Drawing.Color]::White
$DataGridView1.RowsDefaultCellStyle.Font = New-Object System.Drawing.Font("segoe ui",8,[System.Drawing.FontStyle]::Regular)
$DataGridView1.AllowUserToResizeRows = $false
$DataGridView1.RowHeadersVisible = $false
$DataGridView1.Columns.Add(0,"Name") | Out-Null
$DataGridView1.Columns.Add(1,"Duration") | Out-Null
$DataGridView1.Columns.Add(2,"Path") | Out-Null
$DataGridView1.Columns[2].Visible = $false
$DataGridView1.Columns[0].AutoSizeMode = "fill"
$DataGridView1.Columns[1].AutoSizeMode = "ColumnHeader"
$DataGridView1.AllowUserToResizeColumns = $false
$DataGridView1.ColumnHeadersHeight = 30
$DataGridView1.ReadOnly = $true
$DataGridView1.AllowUserToAddRows = $false
$DataGridView1.ColumnHeadersHeightSizeMode = "AutoSize"
$DataGridView1.SelectionMode = "FullRowSelect"
$DataGridView1.location          = New-Object System.Drawing.Point(2,50)


$Form.Controls.AddRange(@($Button,$Button1,$DataGridView1,$TextBox1,$CheckBox1,$CheckBox2,$CheckBox3,$FormMenu,$Label))

## Actions
$Button.Add_Click({ Check-GridValue })
$DataGridView1.Add_CellDoubleClick({ Play-Selected -Video $($DataGridView1.SelectedCells[2].Value) -FullScreen:$CheckBox2.Checked -NoAudio:$CheckBox1.Checked -Repeat:$CheckBox3.Checked })
$Button1.Add_Click({ Fill-DataGrid -DirectoryName $TextBox1.Text })
$FormMenuPlay.Add_Click({ Check-GridValue  })
$FormMenuExit.Add_Click({ $Form.Close() })
$FormMenuFolder.Add_Click({ Save-Dialog })


## Functions
function Play-Selected{
   param(
    
        [string]$Video,
        [switch]$FullScreen,
        [switch]$NoAudio,
        [switch]$Repeat
    
    )

    $Arguments = @()

    if($FullScreen){
        $Arguments += " --fullscreen"
    }
    
    if($NoAudio){
        $Arguments += " --no-audio"
    }

    if($Repeat){
        $Arguments += " --repeat"
    }else{       
        $Arguments += " --play-and-exit"
    }

   vlc `"$Video $Arguments`"

}


function Check-GridValue{

    if(!($DataGridView1.SelectedCells[2].Value) -eq $false){
        Play-Selected -Video $DataGridView1.SelectedCells[2].Value -FullScreen:$CheckBox2.Checked -NoAudio:$CheckBox1.Checked -Repeat:$CheckBox3.Checked
        }else{
        [System.Windows.Forms.MessageBox]::Show(
        "You Must Select a Video",
        "Information",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Information
    )
   }
        
}

function Fill-DataGrid{

  param (
    [string]$DirectoryName
  )

    $Button1.Enabled = $false
    
    $DataGridView1.Rows.Clear()
    
    $Folder = $DirectoryName
    $Shell = New-Object -ComObject shell.application
    $Directory = $Shell.Namespace($Folder)

    Get-ChildItem $($Folder + "\*") -Include "*.mov","*.mp4","*.avi","*.mkv" -File | ForEach-Object { $Item = $Directory.parsename($_.Name)
        $VidInfo = [pscustomobject]@{
            Name = $_.Name.ToString()
            Duration = $Directory.GetDetailsOf($Item, 27)
            Path = $($Folder + "\" + $_.Name)
        }
 
        $DataGridView1.Rows.Add($VidInfo.Name,$VidInfo.Duration,$VidInfo.Path) | Out-Null
    }

  $Button1.Enabled = $true
 
}


function Save-Dialog{


    if ([System.Threading.Thread]::CurrentThread.ApartmentState -ne 'STA') {
        Write-Host "Run this script in STA mode: powershell -STA"
        exit
    }

    # Folder selection dialog
    $folderDialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderDialog.Description = "Select Video Folder To Load"
    $folderDialog.ShowNewFolderButton = $true

    $result = $folderDialog.ShowDialog()

    if(!($folderDialog.SelectedPath) -eq $false){
        $TextBox1.Text = $folderDialog.SelectedPath
        Fill-DataGrid -DirectoryName $TextBox1.Text
    }else{
         return
    }

   

}


## Check for home computers
    if($env:USERDOMAIN -match "DESKTOP-HP" -or "DELL-3470"){
        switch($env:USERDOMAIN){
            "DESKTOP-HP" { $TextBox1.Text = "D:\Videos\Porn" }
            "DELL-3470" { $TextBox1.Text = "C:\Users\dick_\Videos\Pornography" }
        }
    }else{
        $null
    }

[void]$Form.ShowDialog()