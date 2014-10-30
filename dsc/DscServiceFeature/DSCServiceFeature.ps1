configuration DSCServiceFeature
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
   }

}

DSCServiceFeature -ComputerName 'localhost'