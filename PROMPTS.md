# Guía de prompts — Power BI MCP Kit

Antes de empezar:
- Ten **Power BI Desktop abierto** con tu archivo y **guarda (Ctrl+S)**.
- Para cambios en el informe (páginas y visuales), el archivo debe ser **.pbip**. Para el modelo (medidas, tablas, relaciones) sirve también .pbix.
- Abre una **conversación nueva** para cada trabajo grande.

Truco: menciona la skill por su nombre al inicio del prompt ("Usa la skill …"). Así Claude la carga y sigue su procedimiento.

---

## Las skills en una línea

| Skill | Para qué sirve | Úsala cuando quieras… |
|---|---|---|
| **pbi-dashboard** (kit) | Orquestador: arma un dashboard completo de punta a punta | "hazme un dashboard" |
| **optimizar-modelo** (kit, motor DAX Insider) | Revisa la salud del modelo y lo limpia | "revisa / optimiza / limpia mi modelo" |
| **semantic-model-authoring** (Microsoft) | Todo lo del **modelo**: tablas, columnas, medidas, relaciones, DAX, calendario, RLS, parámetros | crear o corregir medidas y relaciones |
| **powerbi-report-cli** (Microsoft) | Todo lo del **informe**: planear, diseñar páginas, crear/editar visuales, validar, capturas, publicar | crear páginas o visuales |
| **deneb-charts** (kit) | Gráficas personalizadas con Deneb (Vega-Lite) | una gráfica que Power BI no trae |
| **html-svg-visuals** (kit) | Tarjetas KPI y mini gráficos con HTML o SVG desde DAX | tarjetas bonitas, sparklines, semáforos |

El MCP **powerbi-modeling-mcp** es la conexión a tu Power BI abierto. Las skills le dicen a Claude *cómo* usarlo bien.

---

## 1. Conectar y entender el modelo
```
Conéctate con powerbi-modeling-mcp al Power BI que tengo abierto y dame un resumen: tablas, columnas clave, relaciones y medidas agrupadas por carpeta.
```
```
Usa la skill semantic-model-authoring. Explícame el modelo como si fuera nuevo en el equipo: qué es hecho, qué es dimensión y cómo se relacionan.
```
```
Lista todas las medidas con su fórmula DAX y dime cuáles no entiendes o parecen tener errores.
```

## 2. Salud y limpieza del modelo (motor DAX Insider)
```
Usa la skill optimizar-modelo. Revisa mi modelo y dame la salud de 0 a 100, los problemas ordenados por impacto y un plan de acción. No cambies nada todavía.
```
```
Usa la skill optimizar-modelo. Busca medidas duplicadas, medidas sin uso, columnas sin uso y claves visibles. Muéstrame la lista antes de borrar o ocultar.
```
```
Usa la skill optimizar-modelo. Revisa la integridad referencial: claves en la tabla de hechos que no existen en la dimensión.
```
```
Usa la skill optimizar-modelo. ¿Qué columnas calculadas debería pasar a Power Query y por qué?
```

## 3. Medidas DAX
```
Usa la skill semantic-model-authoring. Crea medidas de Ventas Totales, Ventas Año Anterior, Variación % y Ventas Acumuladas del año, en la carpeta "Ventas", con formato de moneda.
```
```
Usa la skill semantic-model-authoring. Optimiza la medida [Nombre de medida]: explícame qué hace, por qué es lenta y propón una versión mejor. Aplícala solo si te digo que sí.
```
```
Usa la skill semantic-model-authoring. Organiza todas las medidas en carpetas por tema y agrega una descripción corta a cada una.
```
```
Usa la skill semantic-model-authoring. Crea una tabla de medidas vacía llamada _Medidas y mueve ahí todas las medidas.
```

## 4. Modelo: calendario, relaciones y seguridad
```
Usa la skill semantic-model-authoring. Crea una tabla Calendario completa (año, trimestre, mes con orden correcto, semana, día), márcala como tabla de fechas y relaciónala con mis tablas de hechos.
```
```
Usa la skill semantic-model-authoring. Revisa las relaciones: dirección del filtro, cardinalidad y relaciones inactivas. Corrige las que estén mal y explícame cada cambio.
```
```
Usa la skill semantic-model-authoring. Crea un rol de seguridad (RLS) para que cada vendedor vea solo sus ventas.
```
```
Usa la skill semantic-model-authoring. Crea un parámetro de campo para que el usuario cambie entre Ventas, Costo y Margen en el mismo visual.
```

## 5. Informe: páginas y visuales (requiere .pbip)
```
Usa la skill powerbi-report-cli. Planea un informe para gerencia con este modelo: qué páginas, qué KPIs y qué visuales. Solo el plan, sin construir.
```
```
Usa la skill powerbi-report-cli. Crea una página "Resumen" con 4 tarjetas KPI arriba, una línea de tendencia mensual y una barra por categoría. Usa el tema por defecto de Power BI.
```
```
Usa la skill powerbi-report-cli. Revisa el diseño de la página actual (alineación, espacios, jerarquía visual) y corrígelo. Toma una captura antes y después.
```
```
Usa la skill powerbi-report-cli. Valida el informe y dime si hay visuales rotos o campos que ya no existen.
```

## 6. Dashboard completo en un prompt
```
Usa la skill pbi-dashboard. Crea un dashboard del reporte que tengo abierto.
```
```
Usa la skill pbi-dashboard. Crea un dashboard de 3 páginas (Resumen, Clientes, Operación), con menú de páginas arriba y filtros de año, mes y región.
```

## 7. Visuales personalizados
```
Usa la skill html-svg-visuals. Crea una medida DAX que devuelva una tarjeta KPI en SVG con el valor de [Ventas], la variación vs año anterior y una flecha verde o roja.
```
```
Usa la skill html-svg-visuals. Crea una medida SVG con un sparkline de los últimos 12 meses para usar en una tabla.
```
```
Usa la skill deneb-charts. Crea una gráfica de barras con meta (bullet chart) de Ventas vs Meta por región, con cross-filtering.
```

## 8. Preguntas de negocio sobre tus datos
```
Conéctate al modelo y responde con una consulta DAX: ¿cuáles son los 10 productos con más ventas este año y cuánto crecieron vs el año anterior?
```
```
Analiza los datos del modelo y dame 5 hallazgos de negocio con los números que los respaldan.
```

---

## Consejos
- **Pide primero el plan, luego aplica.** "No cambies nada todavía" evita sorpresas.
- **Guarda en Power BI (Ctrl+S)** antes de pedir cambios en el informe.
- Con datasets grandes, **actualiza los datos tú** desde Power BI (botón Actualizar), no por el MCP.
- Si Claude no se conecta: Power BI abierto + conversación nueva + revisa *Configuración → Desarrollador* que aparezca `powerbi-modeling-mcp`.
