# Reglas del motor DAX Insider

## 2. Qué cuenta como «uso»

Un objeto se considera usado si aparece en cualquiera de estos lugares:

- Visuales: ejes, valores, leyendas, tooltips, campos de cálculos visuales.
- Filtros de visual, de página, de informe y de obtención de detalles (drillthrough), y páginas de tooltip.
- **fx** de los visuales: títulos dinámicos, formato condicional, colores y textos calculados.
- Parámetros de campo (tablas con NAMEOF).
- Cadenas de formato dinámicas de medidas y de elementos de cálculo.
- Expresiones de filas de detalle (detail rows).
- Otras medidas, columnas calculadas, tablas calculadas, grupos de cálculo y roles de seguridad (RLS).
- **Funciones DAX (UDF)**: lo que una función menciona cuenta como uso, aunque la función no se use (eso se avisa aparte). Una columna escrita sin tabla dentro de una función ([Columna]) también cuenta.
- Relaciones (las columnas clave).
- **Informes conectados**: lo que usan los informes secundarios cuenta aparte, y se marca si algo solo lo usa un secundario.

---

### Modelo
- **Peso (VertiPaq)**: tamaño por tabla y columna. *Solo conectado a Power BI Desktop.*
- **Relaciones**: muchos a muchos, filtro en ambos sentidos, ambigüedades, relaciones inactivas sin uso, claves de texto o calculadas, tabla de fechas ausente, fechas automáticas, tablas aisladas.
- **Integridad referencial**: claves del lado «muchos» sin pareja en el lado «uno» (salen como «(En blanco)»), con filas afectadas y ejemplos. *Solo conectado. Solo lee.* Revisa por tandas; una relación lenta queda marcada como «Tardó demasiado» sin frenar las demás. Omite las relaciones muchos a muchos.
- **Medidas**: ficha única por medida (visuales, páginas, informes, tiempo, de qué depende, otros usos, relaciones que activa desde DAX y hallazgos).
- **Duplicadas y similares**.
- **Linaje**: de la medida al visual y a la página.
- **Funciones (UDF)**: cada función DAX del modelo con su descripción, parámetros (tipo y valor por defecto), quién la llama (medidas, columnas, tablas, grupos de cálculo, roles, cálculos visuales, formatos dinámicos, informes conectados y otras funciones), qué usa y su estado (en uso, sin uso, con error). Se leen en vivo y de `functions.tmdl` en PBIP. Necesita Power BI Desktop de junio de 2026 o posterior; en versiones anteriores la sección queda vacía.
- **Objetos calculados**: columnas, tablas y grupos de cálculo.
- **Columnas sin uso**.
- **Seguridad (RLS)**.

### Informe
- **Cadena completa**: medida o columna → medidas → visuales → páginas, con salud de cada visual. Se puede elegir cualquier medida o columna.
- **Lienzo (explorador de páginas)** con capa de **Salud** o de **Carga**.
- **Matriz de uso**, **Impacto al borrar** (simulación, no cambia nada), **medidas implícitas**, **cálculos visuales**, **formato condicional**.
- **Medidas lentas**: ejecuta la consulta del visual principal de cada medida, primero con la caché vacía y luego con caché. *Solo conectado. Solo lee.* Por tandas de 8. Si no hay medidas en visuales (falta el informe), mide todas y lo avisa. Lenta ≥ 0,5 s (revisar) y ≥ 2 s (alta).

### Conectados
- **Mapa de uso**: por cada medida y columna, qué informe la usa: solo el principal, solo secundarios, compartida o ninguno.
- **Informes conectados**: lista y detalle.

### Hallazgos
Cada hallazgo trae severidad (alta, media, baja), por qué importa, cómo se corrige y si DAX Insider puede corregirlo solo.

| Tipo | Qué detecta | Corrección automática |
|---|---|---|
| Medida con error | DAX que no evalúa | No |
| Medida duplicada / similar | Misma fórmula o casi | Eliminar la copia (si es idéntica y sin uso) |
| Medida sin uso | Nadie la usa en ninguna capa | Eliminar |
| Medida implícita | Visual que suma una columna directo | Crear medida explícita |
| Relación usada desde DAX | USERELATIONSHIP sobre relación inexistente, ya activa o inactiva; CROSSFILTER en ambos sentidos | No (sugiere el cambio) |
| Medida lenta | Tiempo con caché vacía | No (da un prompt para optimizar) |
| Columna sin uso | Ninguna capa la usa | Quitar en Power Query o eliminar si es calculada |
| Clave visible | Clave de relación visible en el informe | Ocultar |
| Clave que se suma | Clave numérica con resumen automático | «No resumir» |
| Relación | Reglas de relaciones del módulo Modelo | Dirección sencilla o borrar relación, según el caso |
| Integridad referencial | Claves sin pareja | No (dice qué tabla corregir) |
| Columna calculada | Sin uso, agregaciones, transición de contexto, búsquedas con RELATED, lógica fija | Pasar a Power Query (ver 5) o eliminar |
| Tabla calculada | Sin uso, copias de tablas, resúmenes fijos, tablas vacías | Eliminar (si cumple las condiciones de 6) |
| Función DAX (UDF) | Con error (firma, paréntesis, recursión), sin uso, sin descripción `///` (la usan Copilot e IntelliSense), columnas sin tabla | Eliminar, solo si nada la llama |
| Grupo de cálculo, Seguridad, Organización | Revisión y carpetas | Según el caso |

### IA
- **Prompt** listo para copiar, corto: rol de analista experto en DAX, Power Query y Power BI; por cada punto, el camino sugerido (DAX, Power Query, Modelo o Visual + DAX) y qué hacer; y solo el contexto relacionado: las medidas con sus dependencias, las columnas que usan, las relaciones entre esas tablas y los visuales donde aparecen. Si una medida llama a una función DAX, el prompt incluye el código de la función (y de las que esta llama). Lo que se va a eliminar no lleva contexto.
- **Pegar respuesta de la IA**: lee bloques de DAX y de Power Query de la respuesta y los convierte en cambios con vista previa.
- **MCP**: servidor para Claude y otras IA (ver 7).

---

## 5. Pasar una columna calculada a Power Query

Agrega a la consulta de la tabla el paso «DAX Insider Columna <nombre>» y cambia la columna calculada por una de Power Query **con el mismo nombre**. Los visuales siguen igual.

**Aparece el botón solo si se cumplen todas estas condiciones**
- La fórmula es de una sola fila y se puede traducir.
- La tabla viene de Power Query. Las **tablas hechas con DAX** (por ejemplo CALENDAR) no tienen consulta donde agregar el paso.
- La columna **no está en una relación**.
- Al aplicar también se rechaza si la columna ordena a otra (Ordenar por columna) o está en una jerarquía.

**Se traduce**
- Aritmética, comparaciones, `&&`, `||`, NOT, `&` de texto.
- IF, SWITCH, SWITCH(TRUE()), AND, OR, VAR / RETURN, listas `IN {…}`.
- Texto: UPPER, LOWER, TRIM, LEN, LEFT, RIGHT, MID, SUBSTITUTE, CONCATENATE, CONTAINSSTRING, FORMAT.
- Números: ROUND (redondea como DAX), INT, ABS, DIVIDE, MOD, POWER.
- Fechas: YEAR, MONTH, DAY, HOUR, MINUTE, SECOND, DATE, DATEDIFF (día, mes, trimestre, año), WEEKDAY, WEEKNUM, EOMONTH, EDATE.
- Vacíos: BLANK, ISBLANK, COALESCE.
- Otras columnas calculadas de la misma tabla, si también se pueden traducir.

**No se traduce (se queda en DAX)**
- RELATED / RELATEDTABLE: necesitan combinar consultas.
- CALCULATE, SUMX, COUNTROWS, FILTER, ALL: dependen de otras filas o tablas.
- Medidas usadas dentro de la columna.
- TODAY, NOW, YEARFRAC, STARTOFMONTH, ENDOFMONTH, DATEDIFF por semana u hora.

**Diferencias que avisa**
- Fecha vacía: Power Query deja el resultado vacío (DAX daba el año 1899).
- Celda vacía en una suma: Power Query deja vacío (DAX contaba 0).
- DATE con mes o día fuera de rango: error en Power Query (DAX pasaba al siguiente).
- FORMAT usa la configuración regional del archivo.

---

## 6. Lo que DAX Insider no hace nunca

- **No borra una tabla que guarda medidas**, ni le quita su última columna. Una tabla de medidas nunca aparece como «sin uso» ni «aislada».
- No borra una medida, columna o tabla que algo usa (cualquier capa del punto 2).
- No borra una tabla que participa en relaciones.
- No quita en Power Query una columna calculada, una clave de relación ni una que ordena a otra.
- No cambia el modelo sin vista previa y confirmación del usuario.
- Las consultas de Integridad referencial y Medidas lentas **solo leen**: solo se permiten consultas EVALUATE.
- No envía el modelo ni los datos a internet. La IA solo recibe lo que el usuario copia o lo que pide por MCP.

---

