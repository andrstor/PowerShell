$WinRMCertificateThumbprint = (Get-AzureVM -ServiceName "andreascloud" -Name "andreasdc01" | Select-Object -ExpandProperty VM).DefaultWinRMCertificateThumbprint
(Get-AzureCertificate -ServiceName "andreascloud" -Thumbprint $WinRMCertificateThumbprint -ThumbprintAlgorithm SHA1).Data | Out-File "${env:TEMP}\CloudService.tmp"
 
$X509Object = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2 "$env:TEMP\CloudService.tmp"
$X509Store = New-Object System.Security.Cryptography.X509Certificates.X509Store "Root", "LocalMachine"
$X509Store.Open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadWrite)
$X509Store.Add($X509Object)
$X509Store.Close()
 
Remove-Item "$env:TEMP\CloudService.tmp"