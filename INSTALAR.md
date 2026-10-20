# Instrucciones de instalación (para el agente de IA)

El usuario te pasó este repo y dijo "instalar". Hazlo así, sin pedirle nada más:

0. **Comprueba que corres en la PC Windows del usuario** (no en la nube). Si tu entorno es Linux/macOS o una sesión remota, no instales: dile al usuario que abra la pestaña **`</>` Code** de la app de Claude con entorno **Local** (en su PC) y repita "instalar". Las skills se instalan en su PC y una sesión en la nube no las ve.

1. **Ejecuta el instalador** en PowerShell (en Codex, fuera del sandbox; si te piden permiso, pídele al usuario que lo apruebe):
   ```
   powershell -NoProfile -ExecutionPolicy Bypass -Command "irm 'https://raw.githubusercontent.com/gilvardperez/powerbi-mcp-kit/main/instalar.ps1' | iex"
   ```
   Si no puedes ejecutar comandos (por ejemplo, en el chat normal de Claude), dale al usuario ese comando para que lo pegue en PowerShell.
2. **Lee la línea `RESULTADO`** y confirma que salió OK la línea "Claude Code: verificar skills instaladas". Si dice CON PROBLEMAS, corrige lo listado y vuelve a ejecutarlo (es seguro repetirlo).
3. **Dile al usuario, en este orden:**
   - Cierra Claude por completo (ícono junto al reloj de Windows → Salir) y vuelve a abrirlo.
   - Usa la pestaña **`</>` Code** de la app de Claude, con entorno **Local**, (o Claude Code / Codex / Antigravity). Ahí están todas las skills. El chat normal solo tiene la conexión a Power BI, no las skills.
   - Para comprobar: en una sesión nueva de Code escribe "lista tus skills"; deben aparecer pbi-dashboard, optimizar-modelo, semantic-model-authoring y powerbi-report-cli.
   - En Power BI Desktop: Archivo → Opciones → Características de vista previa → **Power BI Project (.pbip)**.
   - Abre su archivo en Power BI Desktop, guarda (Ctrl+S) y pide: *"Crea un dashboard del reporte que tengo abierto"*.
   - La guía de prompts está en https://github.com/gilvardperez/powerbi-mcp-kit/blob/main/PROMPTS.md

Para actualizar (skills de Microsoft y del kit) se hace lo mismo.
