# Überprüft, ob das aktuelle Verzeichnis ein Git-Repository ist
if (-not (Test-Path ".\.git" -PathType Container)) {
  Write-Error "Dieses Verzeichnis ist kein Git-Repository."
    exit 1
}

try {
# Git pull durchführen
  Write-Host "Führe 'git pull' durch..." -ForegroundColor Cyan
    git pull
    if ($LASTEXITCODE -ne 0) {
      throw "Git pull fehlgeschlagen. Exit-Code: $LASTEXITCODE"
    }

# Docker compose pull durchführen
  Write-Host "Führe 'docker compose pull' durch..." -ForegroundColor Cyan
    docker compose pull
    if ($LASTEXITCODE -ne 0) {
      throw "Docker compose pull fehlgeschlagen. Exit-Code: $LASTEXITCODE"
    }

# Docker compose up durchführen
  Write-Host "Führe 'docker compose up' durch..." -ForegroundColor Cyan
    docker compose up --build -d  # -d: Im Hintergrund laufen lassen
    if ($LASTEXITCODE -ne 0) {
      throw "Docker compose up fehlgeschlagen. Exit-Code: $LASTEXITDE"
    }
  $count = 0
    while ($true) {
      try {
        $HTTP_Request = [System.Net.WebRequest]::Create('http://localhost/')
          $HTTP_Response = $HTTP_Request.GetResponse()
          $HTTP_Status = [int]$HTTP_Response.StatusCode
          If ($HTTP_Status -eq 200) {
            break
          }
      }
      catch {
        write "Site not up... waiting"
          $count = $count+1
          Start-Sleep -seconds 1
      }
      if ($count -gt 10) {
        Write-Error "Giving up"
        exit 1
      }
    }

  $url = Get-Content -Path ".\url.txt" -TotalCount 1
    Start-Process "cmd" -ArgumentList "/c start $url"

    Write-Host "Alle Befehle erfolgreich ausgeführt!" -ForegroundColor Green
}
catch {
  Write-Error "Fehler: $_"
  Write-Error "Docker Desktop Running"
  exit 1
}


