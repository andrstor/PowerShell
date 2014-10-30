configuration NewPullServer
{
param
(
[string[]]$ComputerName = ‘localhost’
)

    Import-DSCResource -ModuleName xPSDesiredStateConfiguration

    Node $ComputerName
    {
        WindowsFeature DSCServiceFeature
        {
        Ensure = “Present”
        Name   = “DSC-Service”
        }

        xDscWebService PSDSCPullServer
        {
        Ensure                  = “Present”
        EndpointName            = “PSDSCPullServer”
        Port                    = 8080
        PhysicalPath            = “$env:SystemDrive\inetpub\wwwroot\PSDSCPullServer”
        CertificateThumbPrint   = “0B8D21D9A61EE3B5737CD7CF9ECC2E19C4661A7A”
        ModulePath              = “$env:PROGRAMFILES\WindowsPowerShell\DscService\Modules”
        ConfigurationPath       = “$env:PROGRAMFILES\WindowsPowerShell\DscService\Configuration”
        State                   = “Started”
        DependsOn               = “[WindowsFeature]DSCServiceFeature”
        }

        xDscWebService PSDSCComplianceServer
        {
        Ensure                  = “Present”
        EndpointName            = “PSDSCComplianceServer”
        Port                    = 9080
        PhysicalPath            = “$env:SystemDrive\inetpub\wwwroot\PSDSCComplianceServer”
        CertificateThumbPrint   = “0B8D21D9A61EE3B5737CD7CF9ECC2E19C4661A7A”
        State                   = “Started”
        IsComplianceServer      = $true
        DependsOn               = (“[WindowsFeature]DSCServiceFeature”,”[xDSCWebService]PSDSCPullServer”)
        }
    }
}

NewPullServer -ComputerName andreascloud.cloudapp.net  

Get-ChildItem -Path .\NewPullServer |
foreach {
 $mof = Get-Content -Path  $psitem.FullName | 
 where {($_ -notlike ' Name=*') -AND ($_ -notlike ' ConfigurationName*')}
 Set-Content -Value $mof -Path $psitem.FullName -Force
}
