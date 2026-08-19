# Merges one provider's env block into Claude Code settings.json WITHOUT
# touching unrelated keys (permissions, enabledPlugins, etc.).
# Replaces the old switcher behavior of overwriting the whole file, which
# stripped those keys and broke every other running Claude Code session.
#
# Conditional args (Model, SmallFast, Opus, Sonnet, Haiku, CompactWindow,
# Effort): set when non-empty, REMOVED when empty - so switching away from a
# provider never leaks its stale model overrides into the next one.
param(
    [Parameter(Mandatory = $true)][string]$SettingsFile,
    [string]$ApiKey = '',
    [string]$BaseUrl = '',
    [string]$AutoUpdates = '',
    [string]$Model = '',
    [string]$SmallFast = '',
    [string]$Opus = '',
    [string]$Sonnet = '',
    [string]$Haiku = '',
    [string]$CompactWindow = '',
    [string]$Effort = '',
    [string]$HookCommand = ''
)

$ErrorActionPreference = 'Stop'

$json = $null
if (Test-Path -LiteralPath $SettingsFile) {
    $json = Get-Content -LiteralPath $SettingsFile -Raw | ConvertFrom-Json
}

# Rebuild top level as a hashtable so we can add/remove keys freely;
# untouched values pass through as-is.
$root = @{}
if ($json) {
    foreach ($p in $json.PSObject.Properties) { $root[$p.Name] = $p.Value }
}

$envH = @{}
if ($root.ContainsKey('env') -and $root['env']) {
    foreach ($p in $root['env'].PSObject.Properties) { $envH[$p.Name] = $p.Value }
}

$envH['ANTHROPIC_AUTH_TOKEN']  = "$ApiKey"
$envH['ANTHROPIC_BASE_URL']    = "$BaseUrl"
$envH['API_TIMEOUT_MS']        = '3000000'
$envH['CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC'] = '1'

$conditional = @{
    'ANTHROPIC_MODEL'             = $Model
    'ANTHROPIC_SMALL_FAST_MODEL'  = $SmallFast
    'ANTHROPIC_DEFAULT_OPUS_MODEL'   = $Opus
    'ANTHROPIC_DEFAULT_SONNET_MODEL' = $Sonnet
    'ANTHROPIC_DEFAULT_HAIKU_MODEL'  = $Haiku
    'CLAUDE_CODE_AUTO_COMPACT_WINDOW' = $CompactWindow
    'CLAUDE_CODE_EFFORT_LEVEL'        = $Effort
}
foreach ($key in $conditional.Keys) {
    if ("$($conditional[$key])" -ne '') { $envH[$key] = "$($conditional[$key])" }
    elseif ($envH.ContainsKey($key))   { $envH.Remove($key) }
}
$root['env'] = $envH

if ($AutoUpdates -ne '') { $root['autoUpdatesChannel'] = "$AutoUpdates" }

# SessionStart hook cleanup: no provider sets one anymore; when the arg is
# empty, remove only our old autostart hook (matched by marker), keeping any
# other hooks the user has.
$marker = 'claude-code-autostart'
if ($HookCommand -ne '') {
    $entry = @{ hooks = @( @{ type = 'command'; command = "$HookCommand"; timeout = 150 } ) }
    $hooksH = @{}
    if ($root.ContainsKey('hooks') -and $root['hooks']) {
        foreach ($p in $root['hooks'].PSObject.Properties) { $hooksH[$p.Name] = $p.Value }
    }
    $existing = @()
    if ($hooksH.ContainsKey('SessionStart')) { $existing = @($hooksH['SessionStart']) }
    # Match on the serialized JSON - hashtables stringify as type names, so
    # a plain -like against the entry object would never see the command path.
    $kept = @($existing | Where-Object { (($_ | ConvertTo-Json -Depth 10 -Compress) -notlike "*$marker*") })
    $hooksH['SessionStart'] = @($kept + $entry)
    $root['hooks'] = $hooksH
}
elseif ($root.ContainsKey('hooks') -and $root['hooks']) {
    $hooksH = @{}
    foreach ($p in $root['hooks'].PSObject.Properties) { $hooksH[$p.Name] = $p.Value }
    if ($hooksH.ContainsKey('SessionStart')) {
        $kept = @($hooksH['SessionStart'] | Where-Object { (($_ | ConvertTo-Json -Depth 10 -Compress) -notlike "*$marker*") })
        if ($kept.Count -gt 0) { $hooksH['SessionStart'] = $kept }
        else { $hooksH.Remove('SessionStart') }
        if ($hooksH.Count -gt 0) { $root['hooks'] = $hooksH } else { $root.Remove('hooks') }
    }
}

$out = $root | ConvertTo-Json -Depth 10
# UTF8 WITHOUT BOM - a BOM makes JSON.parse fail when Claude Code reads settings.
[System.IO.File]::WriteAllText($SettingsFile, $out, (New-Object System.Text.UTF8Encoding($false)))
Write-Output "settings.json updated (merged, other keys preserved)."
