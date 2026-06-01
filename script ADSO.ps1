# 1. Abrir la aplicación VentanaFox desde el escritorio
$appPath = Join-Path $env:USERPROFILE "Desktop\ventanafox.exe"

if (Test-Path $appPath) {
    Start-Process $appPath
    Start-Sleep -Seconds 15 # Esperar a que la app cargue(puse 15 por que suele tardar un rato)
    
    Add-Type -AssemblyName System.Windows.Forms
} else {
    Write-Host "Error: No se encontró la aplicacion ventanafox.exe."
    exit
}

# 2. una vez abierta la app buscamoms el boton de syncro:
# simulamos dos tabulaciones para llegar al boton de start syncronice management que es el segundo que aparece

[System.Windows.Forms.SendKeys]::SendWait("{TAB}{TAB}{ENTER}")

Write-Host "Tarea completada: App abierta y Syncro realizada."