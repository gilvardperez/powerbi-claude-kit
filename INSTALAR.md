# Instrucciones de instalación (para el agente de IA)

El usuario te pasó este repo y dijo "instalar". Hazlo así, sin pedirle nada más:

1. **Ejecuta el instalador** en PowerShell (en Codex, fuera del sandbox; si te piden permiso, pídele al usuario que lo apruebe):
   ```
   powershell -NoProfile -ExecutionPolicy Bypass -Command "irm 'https://raw.githubusercontent.com/gilvardperez/powerbi-mcp-kit/main/instalar.ps1' | iex"
   ```
   Si no puedes ejecutar comandos (por ejemplo, en el chat normal de Claude), dale al usuario ese comando para que lo pegue en PowerShell.
2. **Lee la línea `RESULTADO`.** Si dice CON PROBLEMAS, corrige lo listado y vuelve a ejecutarlo (es seguro repetirlo).
3. **Dile al usuario, en este orden:**
   - Cierra Claude por completo (ícono junto al reloj de Windows → Salir) y vuelve a abrirlo.
   - Usa la pestaña **`</>` Code** de la app de Claude (o Claude Code / Codex / Antigravity). Ahí están todas las skills. El chat normal solo tiene la conexión a Power BI, no las skills.
   - En Power BI Desktop: Archivo → Opciones → Características de vista previa → **Power BI Project (.pbip)**.
   - Abre su archivo en Power BI Desktop, guarda (Ctrl+S) y pide: *"Crea un dashboard del reporte que tengo abierto"*.
   - La guía de prompts está en https://github.com/gilvardperez/powerbi-mcp-kit/blob/main/PROMPTS.md

Para actualizar (skills de Microsoft y del kit) se hace lo mismo.
