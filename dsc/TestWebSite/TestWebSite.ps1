Configuration TestWebSite
{
    param ($MachineName)

    Node $MachineName
        {
        #Install the IIS Role
        WindowsFeature IIS
        {
        Ensure = “Present”
        Name = “Web-Server”
        }
        #Install ASP.NET 4.5
        WindowsFeature ASP
        {
        Ensure = “Present”
        Name = “Web-Asp-Net45”
        }
    }
}

TestWebSite –MachineName “andreascloud.cloudapp.net”

Get-ChildItem -Path .\TestWebSite |
foreach {
 $mof = Get-Content -Path  $psitem.FullName | 
 where {($_ -notlike ' Name=*') -AND ($_ -notlike ' ConfigurationName*')}
 Set-Content -Value $mof -Path $psitem.FullName -Force
}