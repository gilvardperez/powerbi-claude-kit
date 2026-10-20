# Instrucciones para el agente de IA (Claude Code, Codex, Antigravity)

Si el usuario te pasa este repo y te dice "instalar":

1. Ejecuta en PowerShell (en Codex, fuera del sandbox):
   `powershell -NoProfile -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/gilvardperez/powerbi-claude-kit/main/instalar.ps1 | iex"`
2. Lee la última línea `RESULTADO`. Si dice CON PROBLEMAS, corrige lo listado y vuelve a ejecutar: es seguro repetirlo.
3. Dile al usuario: reinicia el agente, activa en Power BI Desktop *Opciones → Vista previa → Power BI Project (.pbip)*, abre su .pbip, guarda y pide "Crea un dashboard del reporte que tengo abierto".

Para actualizar (skills de Microsoft, kit y DAX Insider) se ejecuta el mismo comando.
