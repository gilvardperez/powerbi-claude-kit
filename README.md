# Power BI Claude Kit

Dashboards de Power BI con Claude. Reutiliza las **skills oficiales de Microsoft** (siempre en su última versión) y agrega Deneb, visuales HTML/SVG y **DAX Insider**.

## Instalar

Dile a Claude:

> Instala el MCP de Power BI siguiendo https://gilvardperez.github.io/powerbi-claude-kit/instalar.md

O en PowerShell:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -Command "irm https://gilvardperez.github.io/powerbi-claude-kit/instalar.ps1 | iex"
```

## Actualizaciones

- El MCP oficial corre con `@microsoft/powerbi-modeling-mcp@latest`: siempre la última versión.
- Para traer las skills nuevas de Microsoft y del kit, vuelve a correr el instalador.

## Usar

Abre tu `.pbip` en Power BI Desktop, guarda y di: **"Crea un dashboard del reporte que tengo abierto"**.

---
Hecho por Gilvard Perez · [Club Power BI](https://www.skool.com/club-power-bi-9524) · [DAX Insider](https://daxinsider.netlify.app/)
