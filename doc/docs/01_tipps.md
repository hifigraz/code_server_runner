# Tipps

Die folgenden Tipps verstehen sich als gutgemeinte Ratschläge, wann immer Sie Software entwickeln.

## Virenschutz

Verzichten Sie auf fancy Virenschutzprogramme. Virenschutzprogramme, gerade die mit erweiterten Schutzmechanismen, haben die Aufgabe, die Ausführung unerwünschter Software zu unterbinden. Das tun diese Programme auch oft, indem sie Software blockieren, die sie nicht erkennen und Ihre Herkunft nicht einstufen können.

Es dürfte klar sein, dass die Virenschutzprogramme, die Software nicht kennen, welche Sie gerade in diesem Moment selber erzeugen, also laufen Sie Gefahr hier selbst blockiert zu werden.

Es hat sich gezeigt, dass der Microsoft Defender am wenigsten negativen Einfluss auf einen Softwareentwicklungsprozess zeigt.

## Speicherort

Achten Sie bei der Wahl des Arbeitsverzeichnisses auf folgende Punkte:

- Wählen Sie einen Ordner, den Sie schnell wieder finden.
- Nutzen Sie ein Namensschema, damit Sie hier Ordnung halten können.

      Wie zum Beispiel `/Entwicklung/Jahrgang/Fach`

- Stellen Sie sicher, dass Ihre Daten nicht von OneDrive oder ähnlichen Programmen verwaltet werden.

      Denn bei der Arbeit mit Python-Venvs oder NPM verwalteten Repositorys entstehen Unmengen an Dateien, welche Ihnen solche Dienste bis zur Unbrauchbarkeit verlangsamen können.

- Vermeiden Sie unbedingt Umlaute oder andere Sonderzeichen.

      Auch, wenn es nicht mehr ganz zeitgemäß erscheint, haben leider immer noch viele Programme Probleme mit Umlauten, Bindestrichen, Leerzeichen oder ähnlichem in Dateinamen.

      Deshalb achten Sie darauf, dass Sie nur die Zeichen `[A-Z]`,  `[a-z]`, `[0-9]` und  `[_]` verwenden.

## Versionskontrolle

Arbeiten Sie immer mit Versionskontrollprogrammen, wie zum Beispiel Git.

Erstellen Sie keine Versionen, in dem Sie Kopien von Ordnern anlegen.

Nutzen Sie dafür die richtigen Werkzeuge, also Git.

## Sicherung

Die Verwendung einer Versionskontrolle oder das Verwenden von Cloudspeicher stellen keinen Ersatz für Backups dar.

Besorgen Sie sich einen externen Speicher, auf den Sie in regelmäßigen Abständen Backups erstellen.

Achten Sie darauf, dass dieser Speicher nicht permanent an Ihrem Gerät eingebunden ist, sonst kann es passieren, dass er bei einem Angriff auch in Mitleidenschaft gezogen wird.
