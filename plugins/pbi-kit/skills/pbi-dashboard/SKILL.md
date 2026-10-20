---
name: pbi-dashboard
description: Construye o mejora un dashboard de Power BI (.pbip) abierto en Power BI Desktop a partir de una frase. Usar cuando pidan "crea un dashboard", "mejora este reporte" o similar.
---

# Orquestador de dashboards (Gilvard)

Usa las skills oficiales de Microsoft (`semantic-model-authoring`, `powerbi-report-cli`) y el MCP `powerbi-modeling-mcp` para el trabajo base. Este flujo agrega el toque propio.

1. **Situarse**: `powerbi-desktop status` → instancia abierta, ruta del .pbip, cambios sin guardar. Si hay cambios sin guardar, pedir Ctrl+S antes de seguir.
2. **Auditar con DAX Insider** (skill `dax-insider`): salud del modelo, medidas lentas, relaciones. Guardar la puntuación inicial.
3. **Modelo**: crear calendario, ordenar meses y crear medidas por MCP en un solo lote.
4. **Visuales**: gráficas con `deneb-charts`, tarjetas/KPIs con `html-svg-visuals`. Layout con `powerbi-report-cli`.
5. **Validar y recargar**: `powerbi-report-author validate`, `powerbi-desktop reload --pid <PID>`, `screenshot-all`. Revisar capturas y corregir.
6. **Re-auditar con DAX Insider** y mostrar antes/después + hallazgos de negocio.

Lo que pida el usuario (color, páginas, layout) manda sobre cualquier default.
