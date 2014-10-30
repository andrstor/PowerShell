configuration InstallTFSBuildServer
{
param(
    [string]$node = 'localhost'
)

    Import-DscResource -ModuleName xPSDesiredStateConfiguration
    # One can evaluate expressions to get the node list
    # E.g: $AllNodes.Where("Role -eq Web").NodeName
    node $node
    {

        Archive DSCWave {
        DependsOn = '[Script]DSCWave';
        Ensure = 'Present';
        Path = Join-Path "C:\Program Files\WindowsPowerShell\DSC" -ChildPath "wave7.zip";
        Destination = "$env:ProgramFilesWindowsPowershellModules";
        }

        Script DSCWave 
        {
        GetScript = { @{ Result = (Test-Path -Path (Join-Path "C:\Program Files\WindowsPowerShell\DSC" -ChildPath "wave7.zip")); } };
        SetScript = 
        {
            $Uri = 'https://gallery.technet.microsoft.com/scriptcenter/DSC-Resource-Kit-All-c449312d/file/126120/1/DSC%20Resource%20Kit%20Wave%207%2009292014.zip';
            $OutFile = Join-Path "C:\Program Files\WindowsPowerShell\DSC" -ChildPath "wave7.zip";
            Invoke-WebRequest -Uri $Uri -OutFile $OutFile;
            Write-Verbose "Downloading file to $Outfile";
            Unblock-File -Path $OutFile;
            };
        TestScript = { Test-Path -Path (Join-Path "C:\Program Files\WindowsPowerShell\DSC" -ChildPath "wave7.zip"); }
        }

        #Script TFSServerIso 
        #{
        #GetScript = { @{ Result = (Test-Path -Path (Join-Path "C:\ISOImages" -ChildPath "env_tfs2013_update3.iso")); } };
        #SetScript = 
        #{
        #    $Uri = 'https://portalvhdsn95360wm64779.blob.core.windows.net/isoimages/env_tfs2013_update3';
        #    $OutFile = Join-Path "C:\IsoImages" -ChildPath "env_tfs2013_update3.iso";
        #    Invoke-WebRequest -Uri $Uri -OutFile $OutFile;
        #    Write-Verbose "Downloading file to $Outfile";
        #    Unblock-File -Path $OutFile;
        #    };
        #TestScript = { Test-Path -Path (Join-Path "C:\ISOImages" -ChildPath "env_tfs2013_update3.iso"); }
        #}
        #}

        xRemoteFile Downloader
        {
            Uri = "https://portalvhdsn95360wm64779.blob.core.windows.net/isoimages/env_tfs2013_update3" 
            DestinationPath = Join-Path "C:\IsoImages" -ChildPath "env_tfs2013_update3.iso"
        }

        file tfsserveriso
        {
            ensure = "present"
            DestinationPath = Join-Path "C:\IsoImages" -ChildPath "env_tfs2013_update3.iso"
            type = "file"
            DependsOn = '[xRemoteFile]Downloader'
        } 
        
      #Script InstallTFSServer
      #{
      #    DependsOn = "[File]TFSServerIso"
      #    GetScript =
      #    {
      #        $tfsInstalled = Test-Path –Path "$env:ProgramFiles\Microsoft Team Foundation Server 12.0\Tools\TfsConfig.exe"
      #        $tfsInstalled
      #    }
      #    SetScript =
      #    {
      #        # mount the iso
      #        $setupDriveLetter =  (Mount-DiskImage -ImagePath C:\Temp\vs2013.3_tfs_enu.iso -PassThru | Get-Volume).DriveLetter + ":"
      #        if ($setupDriveLetter -eq $null) {
      #            throw "Could not mount TFS install iso"
      #        }
      #        Write-Verbose "Drive letter for iso is: $setupDriveLetter"
      #         
      #        # run the installer 
      #        $cmd = "$setupDriveLetter\tfs_server.exe /install /quiet"
      #        Write-Verbose "Command to run: $cmd"            
      #        Invoke-Expression cmd | Write-Verbose
      #    }
      #    TestScript =
      #    {
      #        $tfsInstalled = Test-Path –Path "$env:ProgramFiles\Microsoft Team Foundation Server 12.0\Tools\TfsConfig.exe"
      #        if ($tfsInstalled) {
      #            Write-Verbose "TFS server already installed"
      #        } else {
      #            Write-Verbose "TFS server is not installed"
      #        }
      #        $tfsInstalled
      #    }
      #}
      #
      #
      #file tfsserveriso
      #{
      #    ensure = "present"
      #    sourcepath = 
      #    destinationpath = $destinationpath
      #    type = "file"
      #} 
    }      
}
