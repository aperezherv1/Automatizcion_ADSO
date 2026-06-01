# ==============================================================================
# SCRIPT DE AUTOMATIZACIÓN: RESPALDO Y LIMPIEZA DE ARCHIVOS EMPRESARIALES
# Descripcíon: Copia archivos modificados en los últimos X días a una ruta de
#              respaldo y elimina los archivos viejos para ahorrar espacio.
# ==============================================================================

# --- Configuración de Parámetros ---
# Carpeta de trabajo diario
$RutaOrigen      = "D:\Ejercicio\Usuario1\Documentos"

# Carpeta de destino segura       
$RutaRespaldo    = "D:\Ejercicio\Respaldo"

# Límite de tiempo para la vigencia   
$DiasDeRetencion = 30                               
$FechaLimite     = (Get-Date).AddDays(-$DiasDeRetencion)

# Crear la carpeta de respaldo si no existe en el sistema
if (!(Test-Path -Path $RutaRespaldo)) {
    New-Item -ItemType Directory -Force -Path $RutaRespaldo | Out-Null
    Write-Host "Carpeta de respaldo creada con éxito en: $RutaRespaldo" -ForegroundColor Cyan
}

# --- Paso 1: Respaldar archivos recientes ---
Write-Host "Iniciando copia de seguridad..." -ForegroundColor Yellow
$ArchivosARespaldar = Get-ChildItem -Path $RutaOrigen -File -Recurse | Where-Object { $_.LastWriteTime -ge $FechaLimite }

foreach ($Archivo in $ArchivosARespaldar) {
    $RutaDestinoFinal = $Archivo.FullName.Replace($RutaOrigen, $RutaRespaldo)
    $CarpetaDestino   = Split-Path -Parent $RutaDestinoFinal
    
    if (!(Test-Path -Path $CarpetaDestino)) {
        New-Item -ItemType Directory -Force -Path $CarpetaDestino | Out-Null
    }
    
    Copy-Item -Path $Archivo.FullName -Destination $RutaDestinoFinal -Force
}
Write-Host "Respaldo completado." -ForegroundColor Green

# --- Paso 2: Limpieza de archivos obsoletos ---
Write-Host "Buscando archivos con más de $DiasDeRetencion días para eliminar..." -ForegroundColor Yellow
$ArchivosObsoletos = Get-ChildItem -Path $RutaOrigen -File -Recurse | Where-Object { $_.LastWriteTime -lt $FechaLimite }

foreach ($ArchivoViejo in $ArchivosObsoletos) {
    Remove-Item -Path $ArchivoViejo.FullName -Force
    Write-Host "Eliminado: $($ArchivoViejo.Name) (Modificado el: $($ArchivoViejo.LastWriteTime))" -ForegroundColor Gray
}

Write-Host "Proceso de automatización finalizado correctamente." -ForegroundColor Green
