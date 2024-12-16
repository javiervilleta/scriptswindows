# Definir los nombres de los servicios a verificar
$serviceNames = @("Servicename1", "Servicename2", "Servicename3", "Servicename4", "Servicename5")

# Definir la ruta del archivo de log
$logFilePath = "C:\logs\servicios.log"

# Comprobar si la carpeta de logs existe, si no, crearla
if (-not (Test-Path "C:\logs")) {
    New-Item -Path "C:\logs" -ItemType Directory
}

# Obtener la hora actual
$timeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# Iterar sobre cada servicio en la lista
foreach ($serviceName in $serviceNames) {
    # Obtener el estado del servicio
    $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue

    if ($service -eq $null) {
        # Si el servicio no existe
        $logMessage = "$timeStamp - El servicio '$serviceName' no existe en este sistema."
        Add-Content -Path $logFilePath -Value $logMessage
    } elseif ($service.Status -eq 'Running') {
        # Si el servicio está en ejecución
        $logMessage = "$timeStamp - El servicio '$serviceName' ya está en ejecución."
        Add-Content -Path $logFilePath -Value $logMessage
    } else {
        # Si el servicio no está en ejecución
        $logMessage = "$timeStamp - El servicio '$serviceName' no está en ejecución. Intentando iniciarlo..."
        Add-Content -Path $logFilePath -Value $logMessage

        # Intentar iniciar el servicio
        Start-Service -Name $serviceName
        if ((Get-Service -Name $serviceName).Status -eq 'Running') {
            $logMessage = "$timeStamp - El servicio '$serviceName' se inició correctamente."
        } else {
            $logMessage = "$timeStamp - Falló el intento de iniciar el servicio '$serviceName'."
        }
        Add-Content -Path $logFilePath -Value $logMessage
    }
}

# Mensaje de ayuda para agregar más servicios
$logMessage = "$timeStamp - Para agregar más servicios, edite la lista 'serviceNames' en este script."
Add-Content -Path $logFilePath -Value $logMessage
