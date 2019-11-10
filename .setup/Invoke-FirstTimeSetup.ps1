function Get-Folder()
{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")|Out-Null
    $foldername = New-Object System.Windows.Forms.FolderBrowserDialog
    $foldername.Description = "Select Stellaris folder"
    $foldername.rootfolder = "MyComputer"

    if($foldername.ShowDialog() -eq "OK")
    {
        $folder += $foldername.SelectedPath
    }
    return $folder
}

function Test-StellarisPath($stellarisPath) {
    $commonFolderPath = Join-Path -Path $stellarisPath -ChildPath "common"
    echo (Test-Path -Path $commonFolderPath)
    return Test-Path -Path $commonFolderPath
}

$stellarisFolder = Get-Folder
if ((Test-StellarisPath $stellarisFolder) -ne $true) {
    throw "This isn't stellaris folder"
}
$wsCfg = (Get-Content -Encoding UTF8 ./ws-template.json -Raw)
$commonPath = (Join-Path -Path $stellarisFolder -ChildPath "common") -Replace "\\", "\\"
$wsCfg -Replace "{{common-path}}", $commonPath | Out-File -Encoding UTF8 -FilePath "../stellar-logistics.code-workspace"