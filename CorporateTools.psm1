using namespace System.Management
using namespace System.Collections.Generic


enum DriveType {
    Removable = 2
    Fixed = 3
    Network = 4
    Compact = 5
}


class OperatingSystem {
    OperatingSystem([string]$ComputerName, [ManagementBaseObject]$OS) {
        Write-Verbose "Class : OperatingSystem for $ComputerName"
        $this.ComputerName = $ComputerName
        $this.Name = $OS.CSName
        $this.Edition = $OS.Caption
        $this.Build = $OS.BuildNumber
        $this.Version = $OS.Version
        $this.Architecture = $OS.OSArchitecture
        $this.InstallDate = [ManagementDateTimeConverter]::ToDateTime($OS.InstallDate)
        $this.LastBootUpTime = [ManagementDateTimeConverter]::ToDateTime($OS.LastBootUpTime)
        $this.LocalDateTime = [ManagementDateTimeConverter]::ToDateTime($OS.LocalDateTime)
        $this.Drive = $OS.SystemDrive
        $this.Windows = $OS.WindowsDirectory
        $this.System = $OS.SystemDirectory
    }
    [string]$ComputerName
    [string]$Name
    [string]$Edition
    [string]$Architecture
    [string]$Build
    [version]$Version
    [string]$Drive
    [string]$Windows
    [string]$System
    [datetime]$InstallDate
    [datetime]$LastBootUpTime
    [datetime]$LocalDateTime
}

class LogicalDisk {
    LogicalDisk([string]$ComputerName, [ManagementBaseObject]$Disk) {
        Write-Verbose "Class : LogicalDisk for $ComputerName"
        $this.ComputerName = $ComputerName
        $this.DriveLetter = $Disk.DeviceID
        $this.FriendlyName = $Disk.VolumeName
        $this.FileSystem = $Disk.FileSystem
        $this.DriveType = [DriveType]$Disk.DriveType
        $this.SizeRemaining = "$([Math]::Round($Disk.FreeSpace /1GB,2)) GB"
        $this.SizeUsed = "$([Math]::Round(($Disk.Size - $Disk.FreeSpace) /1GB,2)) GB"
        $this.Size = "$([Math]::Round($Disk.Size /1GB,2)) GB"
        $this.FreePercentage = $Disk.Size / $Disk.FreeSpace -as [int]
    }
    [string]$ComputerName
    [string]$DriveLetter
    [string]$FriendlyName
    [string]$FileSystem
    [DriveType]$DriveType
    [string]$SizeUsed
    [string]$SizeRemaining
    [string]$Size
    [int]$FreePercentage
}



function Get-OperatingSystemInformation {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$ComputerName
    )
    
    begin {
        
    }
    
    process {
        Write-Verbose "Function : OperatingSystem Object for $ComputerName"
        $OS = Get-WmiObject -Class "Win32_OperatingSystem" -ComputerName $ComputerName
        [OperatingSystem]::new($ComputerName, $OS)
    }
    
    end {
        
    }
}

function Get-DiskInformation {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string[]]$ComputerName
    )
    
    begin {
        
    }
    
    process {
        Write-Verbose "Function : Logical Disks for All Computers"
        foreach($Computer in $ComputerName){
            Write-Verbose "Function : Logical Disk Object for $Computer"
            foreach ($disk in (Get-WmiObject -Class "Win32_LogicalDisk" -ComputerName $Computer)) {
                [LogicalDisk]::new($Computer, $disk)
            }
        }
    }
    
    end {
        
    }
}