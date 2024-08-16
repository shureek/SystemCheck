Import-Module ./Utils

function Check-DriveSpace {
    [CmdletBinding()]
    param(
        [float]$MinPercent,
        [UInt64]$MinSpace
    )

    Get-DiskDrives | %{
        if (($PSBoundParameters.ContainsKey('MinPercent') -and $_.FreePercent -ge $MinPercent) `
            -or ($PSBoundParameters.ContainsKey('MinSpace') -and $_.FreeSpace -ge $MinSpace)) {
            # OK
        }
        else {
            Write-Output "Drive $($_.Name) has $($_.FreePercent)% ($(bytes2str($_.FreeSpace))) free space"
        }
    }
}

function Check-FreeRAM {
    [CmdletBinding()]
    param(
        [float]$MinPercent,
        [UInt64]$MinSize
    )

    $os = Get-CimInstance Win32_OperatingSystem

    $FreePercent = [Math]::Round($os.FreePhysicalMemory / $os.TotalVisibleMemorySize * 100, 1)
    $FreeMem = $os.FreePhysicalMemory * 1024

    if (($PSBoundParameters.ContainsKey('MinPercent') -and $FreePercent -ge $MinPercent) `
        -or ($PSBoundParameters.ContainsKey('MinSize') -and $FreeMem -ge $MinSize)) {
        # OK
    }
    else {
        Write-Output "$FreePercent% free RAM ($(bytes2str($FreeMem)))"
    }
}

function Check-Service {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string[]]$Name
    )

    Get-Service -Name $Name | ?{ $_.Status -ne 'Running' } | %{
        Write-Output "Service ""$($_.DisplayName)"" is $($_.Status)"
    }
}
