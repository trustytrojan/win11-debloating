param(
	[Parameter(Mandatory)]
	[string]$imagePath
)

$keepRegex = "(Microsoft\.(Wallpaper|Windows\.(Wifi|Ethernet))|Windows\.Kernel.*|OpenSSH.+)"
$toRemove = Get-WindowsCapability -Path mount | ?{ ($_.State -eq "Installed") -and ($_.Name -notmatch $keepRegex) } | %{ $_.Name }

Write-Host "Removing the below capabilities:" -Background Blue
$toRemove
Write-Host "Do you want to proceed? [Y/n]" -NoNewLine -Background Blue
Write-Host " " -NoNewLine

if ((Read-Host) -notin "", "Y", "y") {
	exit
}

foreach ($capabilityName in $toRemove) {
	Write-Host "`nRemoving capability: $capabilityName" -Foreground Blue
	Remove-WindowsCapability -Path $imagePath -Name $capabilityName
}

Write-Host "Finished removing capabilities!" -Foreground Green
