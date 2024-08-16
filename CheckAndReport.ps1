[CmdletBinding()]
param(
    $TelegramToken,
    $TelegramChatID
)

Import-Module ./Telegram

$Messages = & ./CheckAll.ps1 | %{ escape4telegram($_) }
if ($Messages) {
    Send-Telegram "*$(escape4telegram($env:COMPUTERNAME))*`n$($Messages -join "`n")" -ParseMode MarkdownV2 -BotToken $TelegramToken -ChatId $TelegramChatID
}
else {
    Write-Verbose 'All OK'
}
