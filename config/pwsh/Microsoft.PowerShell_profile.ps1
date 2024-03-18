function prompt() {
    $lastStatus = $? ? 0 : ($null -eq $global:LASTEXITCODE ? 1 : $global:LASTEXITCODE) 
    $path = $global:pwd.path.Replace($global:HOME, "~")

    $ansiBold = "`e[1m"

    Write-Host ""
    Write-Host "$ansiBold$path" -ForegroundColor "DarkBlue"
    Write-Host "$lastStatus❯ " -ForegroundColor $($lastStatus -eq 0 ? "DarkGreen" : "DarkRed") -NoNewLine

    $global:LASTEXITCODE = $null
    return "`0"
}

if($PSStyle) {
    $ansiBlue = "`e[34m"
    $ansiRed = "`e[31m"

    $PSStyle.FileInfo.Directory = $ansiBlue
    $PSStyle.FileInfo.Executable = $ansiRed
}

$ansiWhite = "`e[37m"
Set-PSReadLineOption -Colors @{ 
    Default = "White"
    InLinePrediction = "Gray"
}

function neofetch() {
    if(Test-Path ($Bash = $(Join-Path $(Get-Command git | Split-Path) ".." "bin" "bash.exe"))) {
        & $Bash "C:/Users/RYOSU/Projects/new/tutorial/neofetch/neofetch" --config "C:/Users/RYOSU/Projects/new/tutorial/neofetch/config.conf"
        Remove-Variable Bash
    }
}

function ..() {
    Set-Location ..
}

Set-Alias rm rm.exe

$env:XDG_CONFIG_HOME = "$env:USERPROFILE/.config"
$env:XDG_DATA_HOME = "$env:USERPROFILE/.local/share"
