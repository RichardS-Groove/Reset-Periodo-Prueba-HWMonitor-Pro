# Script: Reset-HWMonitorTrial.ps1
# Autor: Ethical Hacker Senior
# Descripción: Rastrea y elimina todas las claves del registro y archivos relacionados con HWMonitor Pro para restablecer el período de prueba.
# Uso: Ejecutar como administrador en un entorno controlado y con fines educativos.

# Configuración inicial
$scriptName = "Reset-HWMonitorTrial"
$logFile = "$env:TEMP\$scriptName.log"
$searchKeyword = "HWMonitor"
$backupPath = "$env:TEMP\HWMonitorBackup"

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
    Write-Log "Buscando y deteniendo procesos de HWMonitor..."

    try {
        $processes = Get-Process -Name "*HWMonitor*" -ErrorAction SilentlyContinue
        if ($processes) {
            Write-Log "Procesos encontrados: $($processes.Count). Deteniéndolos..."
            Stop-Process -Name "*HWMonitor*" -Force -ErrorAction Stop
            Write-Log "Procesos detenidos correctamente."
        } else {
            Write-Log "No se encontraron procesos de HWMonitor en ejecución."
        }
    } catch {
        Write-Log "Error al detener los procesos de HWMonitor: $_" -level "ERROR"
    }
}

# Función para realizar backups de claves y archivos encontrados
function Backup-Data {
    param (
        [string]$path
    )
    try {
        if (-not (Test-Path $backupPath)) {
            New-Item -ItemType Directory -Path $backupPath -Force | Out-Null
        }
        if (Test-Path $path) {
            Write-Log "Realizando backup de ${path}..."
            Copy-Item -Path $path -Destination "$backupPath" -Recurse -Force
            Write-Log "Backup completado: ${path}."
        }
    } catch {
        Write-Log "Error al realizar backup de ${path}: $_" -level "ERROR"
    }
}

# Función para buscar claves del registro relacionadas con HWMonitor
function Search-RegistryForHWMonitor {
    Write-Log "Buscando claves del registro relacionadas con '$searchKeyword'..."
    $foundKeys = @()

    foreach ($hive in "HKCU", "HKLM") {
        try {
            $keys = Get-ChildItem -Path "${hive}:\Software" -Recurse -ErrorAction SilentlyContinue | Where-Object { $_.Name -like "*$searchKeyword*" }
            if ($keys) {
                foreach ($key in $keys) {
                    Write-Log "Clave encontrada: $($key.PSPath)"
                    $foundKeys += $key.PSPath
                }
            }
        } catch {
            Write-Log "Error al buscar en el registro: $_" -level "ERROR"
        }
    }

    if ($foundKeys.Count -eq 0) {
        Write-Log "No se encontraron claves relacionadas con '$searchKeyword'."
    } else {
        Write-Log "Total de claves encontradas: $($foundKeys.Count)"
    }

    return $foundKeys
}

# Función para buscar archivos relacionados con HWMonitor
function Search-FilesForHWMonitor {
    Write-Log "Buscando archivos relacionados con '$searchKeyword'..."
    $foundFiles = @()

    $pathsToSearch = @("$env:LocalAppData", "$env:ProgramData", "C:\Program Files", "C:\Program Files (x86)")

    foreach ($path in $pathsToSearch) {
        try {
            $files = Get-ChildItem -Path $path -Recurse -ErrorAction SilentlyContinue | Where-Object { $_.Name -like "*$searchKeyword*" }
            if ($files) {
                foreach ($file in $files) {
                    Write-Log "Archivo encontrado: $($file.FullName)"
                    $foundFiles += $file.FullName
                }
            }
        } catch {
            Write-Log "Error al buscar archivos en ${path}: $_" -level "ERROR"
        }
    }

    if ($foundFiles.Count -eq 0) {
        Write-Log "No se encontraron archivos relacionados con '$searchKeyword'."
    } else {
        Write-Log "Total de archivos encontrados: $($foundFiles.Count)"
    }

    return $foundFiles
}

# Ejecutar el script principal
Write-Log "Iniciando script $scriptName..."
Write-Log "Buscando y eliminando rastros de HWMonitor Pro..."

try {
    Stop-HWMonitorProcesses
    Write-Log "Rastreo completado."
} catch {
    Write-Log "Error crítico durante la ejecución del script: $_" -level "ERROR"
    Write-Log "El script no pudo completarse correctamente."
    exit 1
}
