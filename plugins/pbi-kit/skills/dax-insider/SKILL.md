---
name: dax-insider
description: Optimiza modelos Power BI con el MCP de DAX Insider (salud 0-100, hallazgos, plan de accion, medidas lentas, impacto al borrar). Usar antes y despues de construir un dashboard, o cuando pidan revisar u optimizar un modelo.
---

# DAX Insider - Optimiza tus reportes Power BI

DAX Insider une tres capas: DAX, modelo semantico y capa visual. Habla por el MCP `dax-insider` y necesita la app abierta y conectada al modelo (Power BI Desktop abierto o carpeta PBIP).

## Flujo
1. `capacidades` una vez por sesion: que hace, que nunca hace. Leela antes de proponer cambios.
2. `estado_modelo`: salud 0-100 y que categorias restan. Siempre primero.
3. `listar_hallazgos` y `plan_de_accion`: que corregir, ordenado por impacto/esfuerzo.
4. Antes de borrar algo: `impacto_al_borrar`.
5. Para corregir: `aplicar_hallazgos` (correcciones automaticas) o `proponer_cambios` (crear/cambiar/eliminar medida, ocultar columna, columna_a_power_query). El usuario ve la vista previa y decide; hay respaldo y Deshacer.
6. Rendimiento: `medidas_lentas` (con `medir=true` mide ahora; puede tardar minutos).
7. Al terminar: `historial_salud` para mostrar el antes y despues.

Otras: `ver_medida`, `buscar_objetos`, `ver_informe`.

## Reglas
- Los visuales se leen del archivo guardado: pide Ctrl+S antes de re-analizar.
- No apliques cambios sin pasar por la vista previa de DAX Insider.
- Si el MCP no responde, pide abrir DAX Insider y conectarlo al modelo.
