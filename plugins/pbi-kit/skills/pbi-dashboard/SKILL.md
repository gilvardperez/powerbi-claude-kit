---
name: pbi-dashboard
description: Construye o mejora un dashboard de Power BI (.pbip) abierto en Power BI Desktop a partir de una frase. Usar cuando pidan "crea un dashboard", "mejora este reporte" o similar.
---

# Orquestador de dashboards (Gilvard)

Conexion SIEMPRE con el MCP `powerbi-modeling-mcp` de Microsoft y las skills oficiales (`semantic-model-authoring`, `powerbi-report-cli`). Nunca abras la app DAX Insider: su motor esta en la skill `optimizar-modelo`.

1. **Situarse**: `powerbi-desktop status` → instancia abierta, ruta del .pbip, cambios sin guardar. Si hay cambios sin guardar, pedir Ctrl+S antes de seguir.
2. **Conectar y entender el modelo** con `powerbi-modeling-mcp`; luego, en segundo plano, aplicar `optimizar-modelo` (motor DAX Insider) y anotar la salud inicial.
3. **Modelo**: crear calendario, ordenar meses y crear medidas por MCP en un solo lote.
4. **Visuales**: nativos de Power BI con `powerbi-report-cli`. Solo si el usuario lo pide: `deneb-charts` o `html-svg-visuals`.
5. **Validar y recargar**: `powerbi-report-author validate`, `powerbi-desktop reload --pid <PID>`, `screenshot-all`. Revisar capturas y corregir.
6. **Cerrar**: capturas, hallazgos de negocio y una linea "salud X → Y" del motor DAX Insider.

## Estilo
Por defecto usa los visuales nativos y el tema por defecto de Power BI (sin importar visuales). Deneb, HTML/SVG o un color de marca solo si el usuario lo pide. Lo que pida el usuario (color, páginas, layout) manda sobre cualquier default.
