

<##

    Takes a screen shot of the current screen and saves it to Temp folder under C drive

##>

    $Screen = [System.Windows.Forms.SystemInformation]::VirtualScreen
    $Width = $Screen.Width
    $Height = $Screen.Height
    $Left = $Screen.Left
    $Top = $Screen.Top
    $DateTime = Get-Date -Format hhmmssMMyyyy
    $File = "C:\Temp\ScreenShot_$($DateTime).jpg"

    $bitmap = New-Object System.Drawing.Bitmap $Width, $Height

    $graphic = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphic.CopyFromScreen($Left, $Top, 0, 0, $bitmap.Size)
    
    $bitmap.Save($File)
    
