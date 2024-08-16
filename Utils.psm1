
function Get-DiskDrives {
    $NameColumn = @{
        Label = 'Name';
        Expression = { $_.DeviceID };
    }

    $LabelColumn = @{
        Label = 'Label';
        Expression = { $_.VolumeName };
    }

    $FreePercentColumn = @{
        Label = 'FreePercent';
        Expression = { [Math]::Round($_.FreeSpace / $_.Size * 100, 1) };
    }

    Get-CimInstance Win32_LogicalDisk -Filter 'DriveType = 3 and Size > 0' |
        select $NameColumn, $LabelColumn, Size, FreeSpace, $FreePercentColumn
}

function span2str([TimeSpan]$span) {
    $sb = [System.Text.StringBuilder]::new()

    if ($span.Days -gt 1) {
        $sb.AppendFormat('{0} days', $span.Days) | Out-Null
    }
    elseif ($span.Days -eq 1) {
        $sb.AppendFormat('{0} day', $span.Days) | Out-Null
    }

    if ($span.Hours -gt 1) {
        $sb.AppendFormat('{0} hours', $span.Hours) | Out-Null
    }
    elseif ($span.Hours -eq 1) {
        $sb.AppendFormat('{0} hour', $span.Hours) | Out-Null
    }

    if ($span.Minutes -gt 0) {
        $sb.AppendFormat('{0} min', $span.Minutes) | Out-Null
    }
    if ($span.Seconds -gt 0) {
        $sb.AppendFormat('{0} sec', $span.Seconds) | Out-Null
    }
    if ($span.Milliseconds -gt 0) {
        $sb.AppendFormat('{0} ms', $span.Milliseconds) | Out-Null
    }

    if ($sb.Length -eq 0) {
        $sb.Append('0 sec') | Out-Null
    }

    return $sb.ToString()
}

function bytes2str($size) {
    if ($size -ge 1GB) {
        return "$([Math]::Round($size / 1GB, 1)) GB"
    }
    elseif ($size -ge 1MB) {
        return "$([Math]::Round($size / 1MB, 1)) MB"
    }
    elseif ($size -ge 1KB) {
        return "$([Math]::Round($size / 1KB, 1)) KB"
    }
    elseif ($size -eq 1) {
        return "$size byte"
    }
    else {
        return "$size bytes"
    }
}
