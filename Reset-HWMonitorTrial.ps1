# Script: Reset-HWMonitorTrial.ps1
# Autor: Richard Campos - Ethical Hacker Senior
# Descripción: Restablece el período de prueba de HWMonitor Pro eliminando claves del registro y archivos de configuración.
# Uso: Ejecutar como administrador en un entorno controlado y con fines educativos.

# Configuración inicial
$scriptName = "Reset-HWMonitorTrial"
$logFile = "$env:TEMP\$scriptName.log"
$regPath = "HKCU:\Software\HWMonitor"
$appDataPath = "$env:LocalAppData\HWMonitor"

# Función para escribir logs
function Write-Log {
    param (
        [string]$message,
        [string]$level = "INFO"
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] [$level] $message"
    Add-Content -Path $logFile -Value $logEntry
    Write-Host $logEntry
}

# Función para detener procesos de HWMonitor
function Stop-HWMonitorProcesses {
    try {
        $processes = Get-Process -Name "HWMonitor" -ErrorAction SilentlyContinue
        if ($processes) {
            Write-Log "Deteniendo procesos de HWMonitor..."
            Stop-Process -Name "HWMonitor" -Force -ErrorAction Stop
            Write-Log "Procesos de HWMonitor detenidos correctamente."
        } else {
            Write-Log "No se encontraron procesos de HWMonitor en ejecución."
        }
    } catch {
        Write-Log "Error al detener los procesos de HWMonitor: $_" -level "ERROR"
        throw
    }
}

# Función para eliminar claves del registro
function Remove-RegistryKeys {
    try {
        if (Test-Path $regPath) {
            Write-Log "Eliminando claves del registro en $regPath..."
            Remove-Item -Path $regPath -Recurse -Force -ErrorAction Stop
            Write-Log "Claves del registro eliminadas correctamente."
        } else {
            Write-Log "No se encontraron claves del registro en $regPath."
        }
    } catch {
        Write-Log "Error al eliminar las claves del registro: $_" -level "ERROR"
        throw
    }
}

# Función para eliminar archivos de configuración
function Remove-ConfigFiles {
    try {
        if (Test-Path $appDataPath) {
            Write-Log "Eliminando archivos de configuración en $appDataPath..."
            Remove-Item -Path $appDataPath -Recurse -Force -ErrorAction Stop
            Write-Log "Archivos de configuración eliminados correctamente."
        } else {
            Write-Log "No se encontraron archivos de configuración en $appDataPath."
        }
    } catch {
        Write-Log "Error al eliminar los archivos de configuración: $_" -level "ERROR"
        throw
    }
}

# Función principal
function Reset-HWMonitorTrial {
    Write-Log "Iniciando script $scriptName..."
    Write-Log "Buscando y eliminando rastros de HWMonitor Pro..."

    try {
        # Detener procesos de HWMonitor
        Stop-HWMonitorProcesses

        # Eliminar claves del registro
        Remove-RegistryKeys

        # Eliminar archivos de configuración
        Remove-ConfigFiles

        Write-Log "Período de prueba de HWMonitor Pro restablecido correctamente."
    } catch {
        Write-Log "Error crítico durante la ejecución del script: $_" -level "ERROR"
        Write-Log "El script no pudo completarse correctamente."
        exit 1
    }

    Write-Log "Script $scriptName finalizado."
}

# Ejecutar la función principal
Reset-HWMonitorTrial