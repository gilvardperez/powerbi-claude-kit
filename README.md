# Power BI Claude Kit

Dashboards de Power BI con Claude. Reutiliza las **skills oficiales de Microsoft** (siempre en su última versión) y agrega Deneb, visuales HTML/SVG y **DAX Insider**.

## Instalar

Pásale a tu agente (Claude Code, Codex o Antigravity) el link de este repo y dile **"instalar"**:

> https://github.com/gilvardperez/powerbi-claude-kit — instalar

El agente sigue [INSTALAR.md](INSTALAR.md). O hazlo tú en PowerShell:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/gilvardperez/powerbi-claude-kit/main/instalar.ps1 | iex"
```

## Qué instala

| Pieza | Origen |
|---|---|
| MCP de modelado Power BI | [Microsoft](https://github.com/microsoft/skills-for-fabric) · `@microsoft/powerbi-modeling-mcp@latest` |
| Skills `semantic-model-authoring` y `powerbi-report-cli` | [skills-for-fabric / powerbi-authoring](https://github.com/microsoft/skills-for-fabric/tree/main/plugins/powerbi-authoring) |
| CLIs `powerbi-report-author` y `powerbi-desktop` | npm de Microsoft (@latest) |
| Skills del kit: dashboard, Deneb, HTML/SVG, DAX Insider | este repo |
| DAX Insider + su MCP (última versión) | [gilvardperez/DaxInsider](https://github.com/gilvardperez/DaxInsider/releases/latest) |

Funciona en **Claude Code, Codex y Antigravity**: el instalador detecta cuáles tienes.

## Actualizaciones

- El MCP oficial corre con `@microsoft/powerbi-modeling-mcp@latest`: siempre la última versión.
- Cada vez que corres el instalador baja la última versión de las skills de Microsoft (rama `main`) y del kit. Es seguro repetirlo; respalda tus configs en `%USERPROFILE%\.pbi-kit\respaldos`.

## Usar

Abre tu `.pbip` en Power BI Desktop, guarda y di: **"Crea un dashboard del reporte que tengo abierto"**.

---
Hecho por Gilvard Perez · [Club Power BI](https://www.skool.com/club-power-bi-9524) · [DAX Insider](https://daxinsider.netlify.app/)
