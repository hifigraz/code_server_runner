# Codeserver

Der Browsergestützte Editor wird als sogenannter Codeserver zur Verfügung gestellt.

Die passiert mithilfe der Containertechnologie.

## Software

Folgende Software ist notwendig, um die Softwareentwicklungsumgebung zu verwenden:

- **Docker** ist eine Software, welche neben dem Starten und Stoppen von Containern, der Verwaltung von Images noch viele andere Aufgaben erfüllt.

      Am einfachsten verwenden Sie unter Windows die [Docker-Desktop](https://www.docker.com/products/docker-desktop/)-Software.

- **Git** ist eine gängige und sehr weit verbreitete Software zur Versionsverwaltung und kooperativen Entwicklung von Sourcecode. Einen [Windows-Installer](https://github.com/git-for-windows/git/releases/download/v2.52.0.windows.1/Git-2.52.0-64-bit.exe) gibt es auch.

- Es ist sinnvoll, einen guten **Editor** direkt auf dem System installiert zu haben, auch wenn die eigentliche Arbeit im Codeserver stattfindet.

## Architektur

Das ganze Environment besteht aus zwei Komponenten.

Ihre Arbeitsumgebung wird über ein GitHub-Repository, in Form von docker-compose Dateien, zur Verfügung gestellt.

Ihre tatsächliche Arbeit wird über ein weiteres GitHub-Repository, zum Beispiel über GitHub Classroom, bereitgestellt.

### Arbeitsumgebung

Die Verwendung von getippten Befehlen in Terminals ist der effektivste Weg, um Ihre Umgebung zu verwalten und zu starten. In einem PowerShell-Terminal können Sie mit dem Befehl `cd` in Verzeichnisse im Dateisystem wechseln. Ist Ihr Arbeitsverzeichnis zum Beispiel `c:\Work\SEW\2526\` können Sie mit folgendem Befehl in dieses Verzeichnis wechseln.

```PowerShell
cd c:\Work\SEW\2526
```

#### Initiales Setup

Das `code_server_runner` Repository kann für verschiedene Softwareentwicklungsaufgaben verwendet werden. Die verschiedenen Aufgaben sind in unterschiedlichen `Branches` implementiert.

Um ein initiales Setup durchzuführen, sollten Sie die folgenden Arbeitsschritte einmal durchführen:

- In das Arbeitsverzeichnis wechseln.
- Das `code_server_runner` Repository klonen.
- In das code_server_runner Verzeichnis wechseln.
- Alle Branches beziehen.
- in den korrekten Branch wechseln.

Für den Fall, dass Ihr Arbeitsverzeichnis `c:\Work\INSY\2526\` ist und Sie `fullstack` Entwicklung durchführen wollen, wären das die folgenden Befehle:

```PowerShell
cd c:\Work\INSY\2526
git clone https://github.com/hifigraz/code_server_runner
cd code_server_runner
git pull --all
git checkout fullstak
```

#### Updaten und Starten

Jedes Mal, wenn Sie die Entwicklungsumgebung brauchen, führen Sie die folgenden Schritte ans Ziel

- Wechseln Sie in das Arbeitsverzeichnis.
- Führen Sie ein Update der Konfiguration durch.
- Führen Sie ein Update der Docker Images durch.
- Bauen Sie die Container neu und starten Sie.
- Öffnen Sie die benötigten URLs, welche von den Containern zur Verfügung gestellt werden.

Mit den folgenden Befehlen können Sie diese Schritte durchführen. Die URLs, die von Ihrem Container bereitgestellt werden, finden Sie in der Datei `urls.txt`

```PowerShell
cd c:\Work\INSY\2526\code_server_runner
git pull
docker compose pull
docker compose up --build -d
```

In der Datei `urls.txt` finden Sie die Webseiten, unter denen die verschiedenen Komponenten zu finden sind

Öffnen Sie nun den Codeserver (üblicherweise die erste URL).

Warten Sie, bis der Editor alle seine Komponenten komplett geladen hat und auch alle Extensions installiert sind.

Vertrauen Sie der Editor-App. Und lassen Sie den Zugriff auf Ihre Zwischenablage zu.

#### Stoppen der Umgebung

Nach getaner Arbeit sollten Sie die Container wieder stoppen, damit Ressourcen wieder freigegeben werden. Bei diesen Ressourcen handelt es sich einerseits um RAM und Prozessorbelastung, die Ihren Stromverbrauch und die Akkuleistung beeinflussen, und andererseits belegen die Container Netzwerkressourcen, die ansonsten nicht zur Verfügung stehen.

Um die Umgebung zu stoppen, benötigen Sie diese folgenden Befehle:

```PowerShell
cd c:\Work\INSY\2526\code_server_runner
docker compose down
```
