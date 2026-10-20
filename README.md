# Power BI MCP Kit

Dashboards de Power BI con Claude. Reutiliza las **skills oficiales de Microsoft** (siempre en su última versión) y agrega Deneb, visuales HTML/SVG y el motor de calidad de **DAX Insider** integrado.

## Instalar

Abre Claude, entra a la pestaña **`</>` Code** con entorno **Local** (o Claude Code / Codex / Antigravity) y escribe:

> https://github.com/gilvardperez/powerbi-mcp-kit — instalar

Eso es todo. El agente sigue [INSTALAR.md](INSTALAR.md), ejecuta el instalador y te dice qué hacer después.

¿Prefieres hacerlo tú? Pega esto en PowerShell:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -Command "irm 'https://raw.githubusercontent.com/gilvardperez/powerbi-mcp-kit/main/instalar.ps1' | iex"
```

**Dónde se usa:** en la pestaña **`</>` Code** de la app de Claude, Claude Code, Codex o Antigravity (ahí están las skills). El chat normal de Claude recibe solo la conexión a Power BI.

## Qué instala

| Pieza | Origen |
|---|---|
| MCP de modelado Power BI | [Microsoft](https://github.com/microsoft/skills-for-fabric) · `@microsoft/powerbi-modeling-mcp@latest` |
| Skills `semantic-model-authoring` y `powerbi-report-cli` | [skills-for-fabric / powerbi-authoring](https://github.com/microsoft/skills-for-fabric/tree/main/plugins/powerbi-authoring) |
| CLIs `powerbi-report-author` y `powerbi-desktop` | npm de Microsoft (@latest) |
| Skills del kit: dashboard, Deneb, HTML/SVG, optimizar-modelo | este repo |
| Motor de calidad del modelo (reglas de DAX Insider), sin abrir la app | skill `optimizar-modelo` |

Funciona en **Claude Code, Codex y Antigravity**: el instalador detecta cuáles tienes.

## Qué le pido

Mira la [guía de prompts](PROMPTS.md): qué hace cada skill y prompts listos para copiar.

## Actualizaciones

- El MCP oficial corre con `@microsoft/powerbi-modeling-mcp@latest`: siempre la última versión.
- Cada vez que corres el instalador baja la última versión de las skills de Microsoft (rama `main`) y del kit. Es seguro repetirlo; respalda tus configs en `%USERPROFILE%\.pbi-kit\respaldos`.

## Usar

Abre tu `.pbip` en Power BI Desktop, guarda y di: **"Crea un dashboard del reporte que tengo abierto"**.

---
Hecho por Gilvard Perez · [Club Power BI](https://www.skool.com/club-power-bi-9524) · [DAX Insider](https://daxinsider.netlify.app/)
