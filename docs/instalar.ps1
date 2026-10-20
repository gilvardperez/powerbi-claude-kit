# Instalador de un comando: irm https://gilvardperez.github.io/powerbi-claude-kit/instalar.ps1 | iex
$ErrorActionPreference = 'Continue'
$ok = @(); $fail = @()
function Paso($n, [scriptblock]$b) { try { & $b; Write-Host "OK  $n" -F Green; $script:ok += $n } catch { Write-Host "X   $n -> $_" -F Red; $script:fail += $n } }

Write-Host "`n== Power BI Claude Kit (Gilvard) ==`n" -F Cyan

Paso "Node.js" {
  if (-not (Get-Command node -EA SilentlyContinue)) {
    winget install -e --id OpenJS.NodeJS.LTS --accept-source-agreements --accept-package-agreements | Out-Null
    $env:Path = [Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [Environment]::GetEnvironmentVariable('Path','User')
  }
  node --version | Out-Null
}

Paso "CLIs de Power BI (Microsoft)" {
  npm i -g @microsoft/powerbi-report-authoring-cli@latest @microsoft/powerbi-desktop-bridge-cli@latest 2>&1 | Out-Null
  if ($LASTEXITCODE) { throw "npm fallo" }
}

if (Get-Command claude -EA SilentlyContinue) {
  Paso "Skills oficiales de Microsoft + MCP Power BI" {
    claude plugin marketplace add https://github.com/microsoft/skills-for-fabric.git 2>&1 | Out-Null
    claude plugin marketplace update fabric-collection 2>&1 | Out-Null
    claude plugin install powerbi-authoring@fabric-collection 2>&1 | Out-Null
  }
  Paso "Kit de Gilvard (Deneb, HTML/SVG, DAX Insider)" {
    claude plugin marketplace add https://github.com/gilvardperez/powerbi-claude-kit.git 2>&1 | Out-Null
    claude plugin marketplace update gilvard-pbi 2>&1 | Out-Null
    claude plugin install pbi-kit@gilvard-pbi 2>&1 | Out-Null
  }
} else {
  Write-Host "!   Claude Code no encontrado. Instalalo y vuelve a correr este comando." -F Yellow
  $fail += "Claude Code"
}

Write-Host ""
if ($fail.Count) { Write-Host "RESULTADO: CON PROBLEMAS -> $($fail -join ', ')" -F Red }
else { Write-Host "RESULTADO: OK. Reinicia Claude, abre tu .pbip y di: 'Crea un dashboard del reporte que tengo abierto'" -F Green }
