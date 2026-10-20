# Power BI Claude Kit - instalador de un comando
#   irm https://raw.githubusercontent.com/gilvardperez/powerbi-claude-kit/main/instalar.ps1 | iex
# Seguro de repetir: cada vez trae la ultima version de las skills de Microsoft y del kit.
$ErrorActionPreference = 'Continue'
$ProgressPreference = 'SilentlyContinue'
$fail = @()
function Paso($n, [scriptblock]$b) { try { & $b; Write-Host "OK  $n" -F Green } catch { Write-Host "X   $n -> $_" -F Red; $script:fail += $n } }
function Aviso($t) { Write-Host "!   $t" -F Yellow }

$H      = $env:USERPROFILE
$Base   = Join-Path $H '.pbi-kit'
$Resp   = Join-Path $Base ('respaldos\' + (Get-Date -f 'yyyyMMdd-HHmmss'))
$MsZip  = 'https://github.com/microsoft/skills-for-fabric/archive/refs/heads/main.zip'
$KitZip = 'https://github.com/gilvardperez/powerbi-claude-kit/archive/refs/heads/main.zip'
$DaxApi = 'https://api.github.com/repos/gilvardperez/DaxInsider/releases/latest'
$DaxDir = Join-Path $env:LOCALAPPDATA 'DAX Insider'
$DaxExe = Join-Path $DaxDir 'DAX Insider.exe'
New-Item -ItemType Directory -Force $Base, $Resp | Out-Null

Write-Host "`n== Power BI Claude Kit (Gilvard Perez) ==`n" -F Cyan

function Escribir($f, $t) { [IO.File]::WriteAllText($f, $t, (New-Object Text.UTF8Encoding $false)) }
function Respaldar($f) { if (Test-Path $f) { Copy-Item $f (Join-Path $Resp ((Split-Path $f -Leaf) + '.bak')) -Force } }

# 1. Node.js
Paso "Node.js" {
  if (-not (Get-Command node -EA SilentlyContinue)) {
    winget install -e --id OpenJS.NodeJS.LTS --accept-source-agreements --accept-package-agreements | Out-Null
    $env:Path = [Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [Environment]::GetEnvironmentVariable('Path','User')
  }
  if (-not (Get-Command node -EA SilentlyContinue)) { throw "instala Node LTS desde nodejs.org" }
}

# 2. CLIs oficiales de Microsoft (siempre @latest)
Paso "CLIs de Power BI (Microsoft, ultima version)" {
  npm i -g @microsoft/powerbi-report-authoring-cli@latest @microsoft/powerbi-desktop-bridge-cli@latest 2>&1 | Out-Null
  if ($LASTEXITCODE) { throw "npm fallo" }
}

# 3. Descargar la ultima version de las skills (Microsoft + kit)
$Src = Join-Path $Base 'src'
Paso "Descargar skills oficiales de Microsoft y del kit" {
  if (Test-Path $Src) { Remove-Item $Src -Recurse -Force }
  New-Item -ItemType Directory -Force $Src | Out-Null
  foreach ($z in @(@($MsZip,'ms'), @($KitZip,'kit'))) {
    $f = Join-Path $Src ($z[1] + '.zip')
    Invoke-WebRequest $z[0] -OutFile $f -UseBasicParsing
    Expand-Archive $f (Join-Path $Src $z[1]) -Force
  }
}
$MsRoot  = Get-ChildItem (Join-Path $Src 'ms')  -Directory | Select-Object -First 1
$KitRoot = Get-ChildItem (Join-Path $Src 'kit') -Directory | Select-Object -First 1
# Skills: las oficiales de Power BI de Microsoft + las del kit
$Skills = @()
if ($MsRoot)  { $Skills += Get-ChildItem (Join-Path $MsRoot.FullName 'plugins\powerbi-authoring\skills') -Directory -EA SilentlyContinue }
if ($KitRoot) { $Skills += Get-ChildItem (Join-Path $KitRoot.FullName 'plugins\pbi-kit\skills') -Directory -EA SilentlyContinue }
$MsCommon = if ($MsRoot) { Join-Path $MsRoot.FullName 'plugins\powerbi-authoring\common' }

function Copiar-Skills($destino) {
  New-Item -ItemType Directory -Force $destino | Out-Null
  foreach ($s in $Skills) {
    $d = Join-Path $destino $s.Name
    if (Test-Path $d) { Remove-Item $d -Recurse -Force }
    Copy-Item $s.FullName $d -Recurse -Force
  }
  # las skills de Microsoft referencian ../../common
  if ($MsCommon -and (Test-Path $MsCommon)) { Copy-Item $MsCommon (Join-Path (Split-Path $destino) 'common') -Recurse -Force }
}

# 4. DAX Insider
Paso "DAX Insider (ultima version de github.com/gilvardperez/DaxInsider)" {
  $rel = Invoke-RestMethod $DaxApi -Headers @{ 'User-Agent' = 'pbi-kit' }
  $ver = Join-Path $DaxDir 'version.txt'
  $tengo = if (Test-Path $ver) { (Get-Content $ver -Raw).Trim() } else { '' }
  if ($tengo -ne $rel.tag_name -or -not (Test-Path $DaxExe)) {
    $asset = $rel.assets | Where-Object { $_.name -like '*.zip' } | Select-Object -First 1
    if (-not $asset) { throw "el release $($rel.tag_name) no trae .zip" }
    Get-Process 'DAX Insider*' -EA SilentlyContinue | Stop-Process -Force
    $zip = Join-Path $env:TEMP $asset.name
    Invoke-WebRequest $asset.browser_download_url -OutFile $zip -UseBasicParsing
    New-Item -ItemType Directory -Force $DaxDir | Out-Null
    $tmp = Join-Path $env:TEMP 'dax-insider-x'; if (Test-Path $tmp) { Remove-Item $tmp -Recurse -Force }
    Expand-Archive $zip $tmp -Force
    $exe = Get-ChildItem $tmp -Recurse -Filter 'DAX Insider.exe' | Select-Object -First 1
    if (-not $exe) { throw "no encontre 'DAX Insider.exe' en $($asset.name)" }
    Copy-Item (Join-Path $exe.DirectoryName '*') $DaxDir -Recurse -Force
    Set-Content $ver $rel.tag_name
  }
}

$MsMcp  = @{ command = 'npx'; args = @('-y','@microsoft/powerbi-modeling-mcp@latest','--start') }
$DaxMcp = @{ command = $DaxExe; args = @('--mcp') }

# 5. Claude Code (busca claude aunque no este en el PATH)
$claude = (Get-Command claude -EA SilentlyContinue).Source
if (-not $claude) {
  $claude = @("$H\.local\bin\claude.exe", "$env:APPDATA\npm\claude.cmd", "$env:LOCALAPPDATA\Programs\claude\claude.exe") |
    Where-Object { Test-Path $_ } | Select-Object -First 1
}
if ($claude) { Set-Alias claude $claude -Scope Script }
if ($claude) {
  Paso "Claude Code: skills + MCP Power BI (Microsoft)" {
    claude plugin marketplace add https://github.com/microsoft/skills-for-fabric.git 2>&1 | Out-Null
    claude plugin marketplace update fabric-collection 2>&1 | Out-Null
    claude plugin install powerbi-authoring@fabric-collection 2>&1 | Out-Null
  }
  Paso "Claude Code: kit de Gilvard" {
    claude plugin marketplace add https://github.com/gilvardperez/powerbi-claude-kit.git 2>&1 | Out-Null
    claude plugin marketplace update gilvard-pbi 2>&1 | Out-Null
    claude plugin install pbi-kit@gilvard-pbi 2>&1 | Out-Null
  }
  Paso "Claude Code: MCP DAX Insider" {
    if (-not ((claude mcp list 2>&1) -match 'dax-insider')) { claude mcp add -s user dax-insider -- "$DaxExe" --mcp 2>&1 | Out-Null }
  }
} else { Aviso "Claude Code no encontrado (se omite). Si lo tienes, reabre la terminal y repite." }

# 6. Codex
$CodexDir = Join-Path $H '.codex'
if ((Get-Command codex -EA SilentlyContinue) -or (Test-Path $CodexDir)) {
  Paso "Codex: skills + MCP" {
    Copiar-Skills (Join-Path $CodexDir 'skills')
    $cfg = Join-Path $CodexDir 'config.toml'
    Respaldar $cfg
    $t = if (Test-Path $cfg) { Get-Content $cfg -Raw } else { '' }
    $daxToml = $DaxExe -replace '\\','\\'
    if ($t -notmatch '\[mcp_servers\.powerbi-modeling-mcp\]') {
      $t += "`n[mcp_servers.powerbi-modeling-mcp]`ncommand = `"npx`"`nargs = [`"-y`", `"@microsoft/powerbi-modeling-mcp@latest`", `"--start`"]`n"
    }
    if ($t -notmatch '\[mcp_servers\.dax-insider\]') {
      $t += "`n[mcp_servers.dax-insider]`ncommand = `"$daxToml`"`nargs = [`"--mcp`"]`n"
    }
    Escribir $cfg $t
  }
} else { Aviso "Codex no encontrado (se omite)" }

# 7. Antigravity
$AgDir = Join-Path $H '.gemini\config'
if (Test-Path (Join-Path $H '.gemini')) {
  Paso "Antigravity: skills + MCP" {
    Copiar-Skills (Join-Path $AgDir 'skills')
    $cfg = Join-Path $AgDir 'mcp_config.json'
    Respaldar $cfg
    $raw = if (Test-Path $cfg) { (Get-Content $cfg -Raw) } else { '' }
    $j = if ($raw -and $raw.Trim()) { $raw.TrimStart([char]0xFEFF) | ConvertFrom-Json } else { [pscustomobject]@{} }
    if (-not $j.mcpServers) { $j | Add-Member mcpServers ([pscustomobject]@{}) -Force }
    if (-not $j.mcpServers.'powerbi-modeling-mcp') { $j.mcpServers | Add-Member 'powerbi-modeling-mcp' ([pscustomobject]$MsMcp) }
    if (-not $j.mcpServers.'dax-insider')          { $j.mcpServers | Add-Member 'dax-insider' ([pscustomobject]$DaxMcp) }
    Escribir $cfg ($j | ConvertTo-Json -Depth 10)
  }
} else { Aviso "Antigravity no encontrado (se omite)" }

Write-Host ""
if ($fail.Count) { Write-Host "RESULTADO: CON PROBLEMAS -> $($fail -join ', ')" -F Red; Write-Host "Respaldos en $Resp" }
else {
  Write-Host "RESULTADO: OK" -F Green
  Write-Host "1) Reinicia tu agente (Claude Code / Codex / Antigravity)."
  Write-Host "2) Power BI Desktop: Opciones > Vista previa > Power BI Project (.pbip)."
  Write-Host "3) Abre tu .pbip, guarda y di: 'Crea un dashboard del reporte que tengo abierto'."
}
