Debian-ISPConfig3-migration
===========================

Dieses Script Dient zur Migration von ISPConfig 3 Daten.

Bitte beachten Sie, dass die Dokumentation noch enwenig dauert.

Gern bin ich bereit, fragen jederzeit zu beantworten.

Das Script ist auf shell basis und kann auf jedem Ubuntu / Debian GNU server genutzt werden.
Script wurde unter Debian Wheezy (7) getestet.

Für ein Feedback würde ich mich freuen.
Bitte beachtet, dass die User / Groups und UNIX-Kennwörter manuell eingefügt werden müssen.

Es werden vom alten Server die Zugangsdaten gespeichert. Dies befindet sich unter dem Verzeichnis /root/old-server/.
(passwd und group)
Die Originale findet Ihr unter /etc/passwd und /etc/group. Diese einfach mit einem editor bearbeiten (vi oder nano)
Beispiel:
cat /root/old-server/passwd
Ausgabe:
replicator:x:1002:1002:,,,:/home/replicator:/bin/bash
Dies einfach kopieren und in die originale einspeichern:
nano /etc/passwd
root:x:0:0:root:/root:/bin/bash
replicator:x:1000:1000:,,,:/home/replicator:/bin/bash
FERTIG!


Download...
Entzip...
chmod 0777
starten!
