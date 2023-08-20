# Check if the drive "Nagpur" is available
$driveNagpur = Get-WmiObject Win32_LogicalDisk | Where-Object { $_.DriveType -eq 2 -and $_.VolumeName -eq "Nagpur" }

if ($driveNagpur) {
    $sourceDrive = "Nagpur"
    Write-Host "Source drive automatically set to $sourceDrive."
} else {
    $sourceDrive = Read-Host "Drive letter not found. Enter the source drive letter (e.g., F):"
}

# Construct the source path
$sourcePath = "${sourceDrive}:\2. AV_Eng_Mar_Hindi_22.0_Win10\2 AV_Mar_22.0_M"

# Check if the source path exists
if (Test-Path -Path $sourcePath -PathType Container) {
    # Destination drive (D:\ or user's desktop)
    $destinationDrive = "D"
    $desktopPath = [System.Environment]::GetFolderPath("Desktop")
    
    # Construct the destination paths
    $destinationPathD = "${destinationDrive}:\"
    $destinationPathDesktop = Join-Path -Path $desktopPath -ChildPath "CBM"
    
    # Create CBM folder on user's desktop if it doesn't exist
    if (-not (Test-Path -Path $destinationPathDesktop -PathType Container)) {
        New-Item -Path $destinationPathDesktop -ItemType Directory | Out-Null
    }
    
    # Copy files and folders to the destination
    Write-Host "Copying files to destination..."
    Copy-Item -Path $sourcePath -Destination $destinationPathD -Recurse -Force
    Copy-Item -Path $sourcePath -Destination $destinationPathDesktop -Recurse -Force

    Write-Host "All files copied successfully."

    # Base path for the numbered folders
    $numberedFoldersPath = "D:\2 AV_Mar_22.0_M"

    # Loop through each numbered folder (1 to 10)
    1..10 | ForEach-Object {
        $folderNumber = $_
        $folderPath = Join-Path -Path $numberedFoldersPath -ChildPath $folderNumber

        # Check if the folder exists
        if (Test-Path -Path $folderPath -PathType Container) {
            $exeFileName = "Class ${folderNumber}_M.exe"
            $exeFilePath = Join-Path -Path $folderPath -ChildPath $exeFileName

            # Check if the executable file exists
            if (Test-Path -Path $exeFilePath -PathType Leaf) {
                $shortcutName = "Class ${folderNumber}_M.lnk"
                $shortcutPath = Join-Path -Path $desktopPath -ChildPath $shortcutName

                # Create the shortcut
                $WshShell = New-Object -ComObject WScript.Shell
                $Shortcut = $WshShell.CreateShortcut($shortcutPath)
                $Shortcut.TargetPath = $exeFilePath
                $Shortcut.Save()

                Write-Host "Shortcut for $exeFileName created on the desktop."
            } else {
                Write-Host "Executable file $exeFileName not found in folder $folderNumber."
            }
        } else {
            Write-Host "Folder $folderNumber does not exist."
        }
    }

} else {
    Write-Host "Source path not found."
}
