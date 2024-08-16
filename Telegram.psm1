$TelegramHost = 'api.telegram.org'
$TelegramBotToken = ''

function Send-Telegram {
    [CmdletBinding()]
    param(
        [parameter(Mandatory=$true, Position=0)]
        [string]$Text,
        [string][long]$ChatId,
        [ValidateSet('Markdown', 'MarkdownV2', 'HTML')]
        [string]$ParseMode = 'MarkdownV2',
        [switch]$NoPreview,
        $TelegramHost = $script:TelegramHost,
        $BotToken = $script:TelegramBotToken
    )

    Write-Verbose "Send-Telegram '$Text'"

    if ([string]::IsNullOrWhiteSpace($BotToken)) {
        Write-Error -Message "BotToken is not specified" -Category InvalidArgument -ErrorAction Stop
    }

    if ($NoPreview) { $disable_preview = 'True' } else { $disable_preview = '' }

    $payload = @{
        chat_id = $ChatId;
        text = $Text;
        disable_web_page_preview = $disable_preview;
    }
    if ($PSBoundParameters.ContainsKey('ParseMode')) {
        $payload['parse_mode'] = $ParseMode
    }

    Invoke-WebRequest `
        -Uri "https://$TelegramHost/bot$BotToken/sendMessage" `
        -Method Post `
        -ContentType "application/json;charset=utf-8" `
        -Body (ConvertTo-Json -Compress -InputObject $payload) | Out-Null
}

function Get-TelegramUpdate {
    [CmdletBinding()]
    param(
        $TelegramHost = $script:TelegramHost,
        $BotToken = $script:TelegramBotToken
    )

    if ([string]::IsNullOrWhiteSpace($BotToken)) {
        Write-Error -Message "BotToken is not specified" -Category InvalidArgument -ErrorAction Stop
    }

    $Result = Invoke-WebRequest `
        -Uri "https://$TelegramHost/bot$BotToken/getUpdates" `
        -Method Post

    if ($Result.Headers['Content-Type'] -eq 'application/json') {
        return $Result.Content | ConvertFrom-Json
    }
    else {
        return $Result.Content
    }
}

function escape4telegram([string]$message) {
    return $message.
        Replace('\', '\\').
        Replace('*', '\*').
        Replace('[', '\[').
        Replace(']', '\]').
        Replace('(', '\(').
        Replace(')', '\)').
        Replace('~', '\~').
        Replace('`', '\`').
        Replace('>', '\>').
        Replace('#', '\#').
        Replace('+', '\+').
        Replace('-', '\-').
        Replace('=', '\=').
        Replace('|', '\|').
        Replace('{', '\{').
        Replace('}', '\}').
        Replace('.', '\.').
        Replace('!', '\!')
}

Export-ModuleMember -Variable *
Export-ModuleMember -Function *
[System.Net.ServicePointManager]::SecurityProtocol = 'Tls,Tls11,Tls12'
