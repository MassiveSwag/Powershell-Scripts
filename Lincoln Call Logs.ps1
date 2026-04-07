<# 

.NAME
    Lincoln Call Logs

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

$1stHTML = "
            <!DOCTYPE HTML>
            <html>
            <head>
            <style>
            html {
                background-color: #F0F0F0
            }
            </style>
            </head>
            <body>
            </body>
            </html>
            "

Hide-Console | Out-Null


$InternetConnection = Test-Connection "Google.com" -Count 1 -Quiet

Add-Type -AssemblyName System.Windows.Forms


# Form Controls

[System.Windows.Forms.Application]::EnableVisualStyles()

$LabelFont                       = [System.Drawing.Font]::new('Impact', 18, [System.Drawing.FontStyle]::Bold)
$FormFont                        = [System.Drawing.Font]::new('Microsoft Sans Serif', 10, [System.Drawing.FontStyle]::Regular)
$DataFont                        = [System.Drawing.Font]::new('Oswald', 7, [System.Drawing.FontStyle]::Regular)

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = '1100,575'
$Form.text                       = "  Lincoln Call Logs"
$Form.FormBorderStyle            = "FixedToolWindow"
$Form.BackColor                  = "#F0F0F0"
$Form.TopMost                    = $false

$DateTimePicker                        = New-Object System.Windows.Forms.DateTimePicker
$DateTimePicker.width                  = 279
$DateTimePicker.height                 = 20
$DateTimePicker.location               = New-Object System.Drawing.Point(10,10)
$DateTimePicker.Font                   = $FormFont
$DateTimePicker.Format = "Custom"
$DateTimePicker.CustomFormat = "M-d-yyyy"

$Button1                         = New-Object system.Windows.Forms.Button
$Button1.text                    = "Call Logs"
$Button1.FlatStyle               = "Flat"
$Button1.BackColor               = "#515A5A"
$Button1.ForeColor               = "#FFFFFF"
$Button1.width                   = 80
$Button1.height                  = 25
$Button1.location                = New-Object System.Drawing.Point(290,9)
$Button1.Font                    = $FormFont

$Button2                         = New-Object system.Windows.Forms.Button
$Button2.text                    = "Incedent Report"
$Button2.FlatStyle               = "Flat"
$Button2.BackColor               = "#515A5A"
$Button2.ForeColor               = "#FFFFFF"
$Button2.width                   = 120
$Button2.height                  = 25
$Button2.location                = New-Object System.Drawing.Point(371,9)
$Button2.Font                    = $FormFont

$Label                           = New-Object System.Windows.Forms.Label
$Label.Height                    = 500
$Label.Width                     = 1100
$Label.ForeColor                 = "#F0F0F0"
$Label.Text                      = "NO INTERNET CONNECTION"
$Label.TextAlign                 = "MiddleCenter"
$Label.Location                  = New-Object System.Drawing.Point(0,0)
$Label.Font                      = $LabelFont



$DataGridView1                   = New-Object system.Windows.Forms.DataGridView
$DataGridView1.width             = 595
$DataGridView1.height            = 525
$DataGridView1.ShowCellToolTips  = $true
$DataGridView1.RowHeadersVisible = $false
$DataGridView1.ColumnHeadersBorderStyle = "Raised"
$DataGridView1.SelectionMode     = "FullRowSelect"
$DataGridView1.RowHeadersWidthSizeMode = "Disable"
$DataGridView1.AllowUserToResizeRows = $false
$DataGridView1.AllowUserToResizeColumns = $false
$DataGridView1.ColumnHeadersHeightSizeMode = "DisableResizing"
$DataGridView1.AutoSizeColumnsMode = "Fill"
$DataGridView1.Columns.Add(0,"Date") | Out-Null
$DataGridView1.Columns.Add(1,"Time") | Out-Null
##$DataGridView1.Columns.Add(2,"Case") | Out-Null
$DataGridView1.Columns.Add(3,"Location") | Out-Null
$DataGridView1.Columns.Add(4,"Type") | Out-Null
$DataGridView1.location          = New-Object System.Drawing.Point(10,40)
$DataGridView1.Font              = $DataFont

$TabControl                     = New-Object System.Windows.Forms.TabControl
$TabControl.Location            = New-Object System.Drawing.Point(610,18)
$TabControl.Width               = 485
$TabControl.Height              = 549

$TabPage1                       = New-Object System.Windows.Forms.TabPage
$TabPage1.Text                  = "Incedent Tab"

$TabPage2                       = New-Object System.Windows.Forms.TabPage
$TabPage2.Text                  = "Call Log Search"

# Tabpage1

$WebBrowser                      = New-Object System.Windows.Forms.WebBrowser
$WebBrowser.Width                = 470
$WebBrowser.Height               = 540
$WebBrowser.AutoSize             = $true
$WebBrowser.ScrollBarsEnabled    = $false
$WebBrowser.ForeColor            = "#F0F0F0"
$WebBrowser.DocumentText         = $1stHTML.ToString()
$WebBrowser.Location             = New-Object System.Drawing.Point(5,5)

#Tabpage2

$SearchBox                       = New-Object System.Windows.Forms.TextBox
$SearchBox.Width                 = 300
$SearchBox.Height                = 20
$SearchBox.Font                  = $FormFont
$SearchBox.Location              = New-Object System.Drawing.Point(10,10)

$SearchButton                    = New-Object System.Windows.Forms.Button
$SearchButton.Width              = 70
$SearchButton.Height             = 25
$SearchButton.Text               = "Search"
$SearchButton.FlatStyle          = "Flat"
$SearchButton.BackColor          = "#515A5A"
$SearchButton.ForeColor          = "#FFFFFF"
$SearchButton.Font               = $FormFont
$SearchButton.Location           = New-Object System.Drawing.Point(315,9)

$ComboListBox                    = New-Object System.Windows.Forms.ComboBox
$ComboListBox.Text               = "Column"
$ComboListBox.Width              = 80
$ComboListBox.Height             = 25
$ComboListBox.Items.AddRange(@("Date","Time","Location","Type"))
$ComboListBox.Font               = $FormFont
$ComboListBox.Location           = New-Object System.Drawing.Point(390,10)

$DataGridView2                   = New-Object system.Windows.Forms.DataGridView
$DataGridView2.width             = 460
$DataGridView2.height            = 450
$DataGridView2.ShowCellToolTips  = $true
$DataGridView2.RowHeadersVisible = $false
$DataGridView2.ColumnHeadersBorderStyle = "Raised"
$DataGridView2.SelectionMode     = "FullRowSelect"
$DataGridView2.RowHeadersWidthSizeMode = "Disable"
$DataGridView2.AllowUserToResizeRows = $false
$DataGridView2.AllowUserToResizeColumns = $false
$DataGridView2.ColumnHeadersHeightSizeMode = "DisableResizing"
$DataGridView2.AutoSizeColumnsMode = "Fill"
$DataGridView2.Columns.Add(0,"Date") | Out-Null
$DataGridView2.Columns.Add(1,"Time") | Out-Null
$DataGridView2.Columns.Add(2,"Location") | Out-Null
$DataGridView2.Columns.Add(3,"Type") | Out-Null
$DataGridView2.location          = New-Object System.Drawing.Point(10,40)
$DataGridView2.Font              = $DataFont




if($InternetConnection -eq $true)
{
    $Form.Controls.AddRange(@($DateTimePicker,$Button1,$DataGridView1,$TabControl))
    $TabControl.Controls.AddRange(@($TabPage2))
    $TabPage1.Controls.Add($WebBrowser)
    $TabPage2.Controls.AddRange(@($SearchBox,$SearchButton,$DataGridView2,$ComboListBox))
}else{
    $Form.controls.AddRange(@($Label))
}

# Button Controls

$Button1.Add_Click({ Get-CallLog })
$SearchButton.Add_Click({ Search-Records })

# Functions
function Get-CallLog
{
    $DataGridView1.Rows.Clear()
    $DataGridView1.AutoSizeColumnsMode = "Fill"

    [uri]$CallLogURL = "HTTPs://CJIS.lincoln.ne.gov/HTBIN/CGI.com"

    $Global:LincolnCallLogs = Invoke-WebRequest -Uri $CallLogURL -UseBasicParsing


    ##($LincolnCallLogs.Forms | Select-Object -Property Fields -ExpandProperty Fields).date = $DateTimePicker.Text

    $Body = @{
    CGI ="disk0:[020020.www]pub_cfssel.com";
    date =$DateTimePicker.Text;
    CSV ="Display List as CSV File";
    }


    $CSV = Invoke-WebRequest -Uri ($CallLogURL) -Method Post -Body $Body -UseBasicParsing

    $CSVFile = $CSV.Content -replace "<HTML><BR><PRE>", ""

    #$CSVFile | Out-File -LiteralPath "C:\Temp\Police.txt" -Force
    #$Import = Import-Csv -LiteralPath "C:\Temp\Police.txt" -Delimiter ","

    $Global:Import = @(ConvertFrom-Csv -InputObject $CSVFile)

        foreach($Line in $Import)
        {
            $Time = $Line.Time
            $TimeOfReport = Get-Date -Hour (($Time[0]) + ($Time[1])) -Minute (($Time[2]) + ($Time[3])) -Format '%h:mm tt'
            $DataGridView1.Rows.Add($Line.Date,$TimeOfReport,$Line.Location,$Line.Type)
        }

    $DataGridView1.AutoSizeColumnsMode = "Fill"

    $Form.UseWaitCursor = $false
       
}
function Text-Box
{
   
    if($DateTimePicker.Text -eq $null)
    {
        $DateTimePicker.Text = $(Get-Date -Format M-d-yyyy).ToString()
        }else{
        $DateTimePicker.Text = $null
        }
}

function Get-Incedent
{
    $IncedentURL = "https://lincoln.ne.gov/city/police/stats/incidentreports.htm"
    $PostSite = "/HTBIN/CGI.COM HTTP/1.1"
    $IncedentLookUp = Invoke-WebRequest -Uri $IncedentURL

    $CONumber = ($DataGridView1.SelectedCells | Where-Object { $_.ColumnIndex -eq 2 }).FormattedValue
    $CGI = "CGI=DISK0%3A%5B020020.WWW%5DPUB_CASE.COM&"
    $pubir = "pubir=$CONumber"
       
    $Table = Invoke-WebRequest -Uri "https://cjis.lincoln.ne.gov/HTBIN/CGI.COM?$($CGI + $pubir)"


    $Report = $Table.ParsedHtml.getElementsByTagName("TABLE")  | Where-Object { $_.uniqueNumber -eq 1 } | Select-Object -Property innerHtml -ExpandProperty innerHtml
        
        if($Report -contains "*<TD>*")
    {
        $HTML = "
            <!DOCTYPE HTML>
            <html>
            <head>
            <style>
            html {
                background-color: #F0F0F0
            }
            </style>
            </head>
            <body>
            <p>No Record Found</p>
            </body>
            </html>
            "
    }else{
        $HTML = "
            <!DOCTYPE HTML>
            <html>
            <head>
            <style>
            html {
                background-color: #F0F0F0;
            }
            div {
                text-align: center;
                width: auto;
                height: 300px;

            }
            table {
                width: 95%;
                background-color: #FFFFFF;
            }
            table {
                border: 1px solid black;
            }
            B {
                font-size: 12px;
                padding: 1px;
                margin: 1px;
            }
            tr {
                margin: 2px;
                padding: 20px;
            }
            font {
                font-size: 14px;
            }
            </style>
            </head>
            <body>
            <div>
            <table>
                $Report
            </table>
            </div>
            </body>
            </html>
            "
    }

    $WebBrowser.DocumentText = $HTML.ToString()

}

function Search-Records
{
    $DataGridView2.Rows.Clear()
    $DataGridView2.AutoSizeColumnsMode = "Fill"
    
    $SearchCritia = @($Import | Select-Object -Property *)
    $Finding = @()
        foreach($Items in $SearchCritia)
        {
            $Finding += ($Items | Where-Object { $_.$($ComboListBox.SelectedItem) -like "*$($SearchBox.Text.ToString())*" })
        }

        foreach($Find in $Finding)
        {
            $Time = $Finding.Time
            $TimeOfReport = Get-Date -Hour (($Time[0]) + ($Time[1])) -Minute (($Time[2]) + ($Time[3])) -Format '%h:mm tt'
            $DataGridView2.Rows.Add($Find.DATE,$TimeOfReport,$Find.LOCATION,$Find.TYPE)
        }

}

<#
$Selection = ($DataGridView2.SelectedCells | Where-Object { $_.ColumnIndex -eq 2 } | Select-Object -Property Value -ExpandProperty Value).ToString()
$DataGridView2.Add_Click({ $DataGridView1. })
#>

[void]$Form.ShowDialog()