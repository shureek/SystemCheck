[CmdletBinding()]
param(
    [Parameter(Mandatory=$true, Position=0)]
    [Alias("Token")]
    $TelegramToken
)

Import-Module ./Telegram

# Getting chat ID
$answer = Get-TelegramUpdate -BotToken $TelegramToken
if ($answer.ok) {
    $answer.result | %{ $_.message }
}
else {
    $answer
}
