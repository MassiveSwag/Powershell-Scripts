<# This form was created using POSHGUI.com  a free online gui designer for PowerShell
.NAME
    Untitled
#>

# .Net methods for hiding/showing the console in the background
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

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

Hide-Console | Out-Null

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = New-Object System.Drawing.Point(382,190)
$Form.text                       = " IP Location"
$Form.TopMost                    = $false

$TextBox1                        = New-Object system.Windows.Forms.TextBox
$TextBox1.multiline              = $false
$TextBox1.width                  = 263
$TextBox1.height                 = 20
$TextBox1.location               = New-Object System.Drawing.Point(6,8)
$TextBox1.Font                   = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$Button1                         = New-Object system.Windows.Forms.Button
$Button1.text                    = "Find IP"
$Button1.FlatStyle               = "flat"
$Button1.width                   = 101
$Button1.height                  = 25
$Button1.location                = New-Object System.Drawing.Point(275,7)
$Button1.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$DataGridView1                   = New-Object system.Windows.Forms.DataGridView
$DataGridView1.width             = 368
$DataGridView1.height            = 144
$DataGridView1.AutoSizeColumnsMode = "Fill"
$DataGridView1.Columns.Add(0,"City") | Out-Null
$DataGridView1.Columns.Add(1,"State") | Out-Null
$DataGridView1.Columns.Add(2,"ZIP") | Out-Null
$DataGridView1.Columns.Add(3,"Location") | Out-Null
$DataGridView1.RowHeadersVisible  = $false
$DataGridView1.location          = New-Object System.Drawing.Point(7,36)

$Form.controls.AddRange(@($TextBox1,$Button1,$DataGridView1))

$Button1.Add_Click({ Get-IPLocation -IP $TextBox1.Text })
$DataGridView1.Add_Click({ Show-Location })


#Write your logic code here

function Get-IPLocation{

    [CmdletBinding()]
        param(
            [Parameter(Mandatory=$false,
            Position=0)]
            [string]
            $IP
        )
            [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]'Tls,Tls11,Tls12'

            $WebRequest = Invoke-RestMethod -Uri "https://ipinfo.io/$IP" -UseBasicParsing
            
            $DataGridView1.Rows.Add($WebRequest.city,$WebRequest.region,$WebRequest.postal,$WebRequest.loc)

            $Global:Location = $WebRequest.loc
           
}

function Show-Location {

     $LocationArray = @($Location -split ",")
     Start-Process -FilePath Chrome -ArgumentList "https://www.google.com/maps/search/?api=1&query=$($LocationArray[0]),$($LocationArray[1])"
}

[System.Windows.Forms.Application]::Run($Form)