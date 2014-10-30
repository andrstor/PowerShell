Configuration SetPullMode
    {
    param([string]$guid, [string]$computername)
    

    Node $computername
    {
        LocalConfigurationManager
        {
        ConfigurationMode = ‘ApplyAndAutoCorrect’
        ConfigurationID = $guid
        RefreshMode = ‘Pull’
        RefreshFrequencyMins = 15
        RebootNodeIfNeeded = $true
        DownloadManagerName = ‘WebDownloadManager’
        DownloadManagerCustomData = @{
        ServerUrl = ‘https://andreasdc01.test.andreas.no:8080/PSDSCPullServer/PSDSCPullServer.svc/';
                 AllowUnsecureConnection = ‘false’ }
        }
    }
}

$guid = '315c4b90-9dda-4117-b19a-6f019708b226'
SetPullMode –guid $guid -computername andreascloud.cloudapp.net

Get-ChildItem -Path .\SetPullMode |
foreach {
 $mof = Get-Content -Path  $psitem.FullName | 
 where {($_ -notlike ' Name=*') -AND ($_ -notlike ' ConfigurationName*')}
 Set-Content -Value $mof -Path $psitem.FullName -Force
}
#Set-DSCLocalConfigurationManager –Computer server2.contoso.com 
#-Path ./SetPullMode –Verbose
