Get-ChildItem -Path ".\" -Filter "*.psd1" | Copy-Item -Destination "$HOME\Documents\WindowsPowerShell\Modules\CorporateTools"
Get-ChildItem -Path ".\" -Filter "*.psm1" | Copy-Item -Destination "$HOME\Documents\WindowsPowerShell\Modules\CorporateTools"
Remove-Module -Name "CorporateTools" -Force -ErrorAction SilentlyContinue
Import-Module -Name "CorporateTools" -Force

Write-Host "Operating System Information" -ForegroundColor Yellow
Get-OperatingSystemInformation -ComputerName localhost
Write-Host "Disk Information" -ForegroundColor Yellow
Get-DiskInformation -ComputerName localhost,CORSAIRONEPRO | Format-Table
