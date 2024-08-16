Import-Module ./Checks

Check-DriveSpace -MinPercent 10 -MinSpace 100GB
Check-FreeRAM -MinSize 1GB

$ServiceNames = @(
    '1C:Enterprise 8.3 Server Agent (x86-64)'
    'MSSQLSERVER'
    'SQLSERVERAGENT'
)
Check-Service $ServiceNames
