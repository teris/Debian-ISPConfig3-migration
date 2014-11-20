#!/bin/bash
#
  echo "############################################################"
  echo "##                   Herzlich Willkommen                  ##"
  echo "##   Bitte beachten Sie alle Hinweise und Empfehlungen    ##"
  echo "##                                                        ##"
  echo "##   Bei Fragen oder Problemen können Sie jederzeit       ##"
  echo "##   unter http://wiki.teris-cooper.de nachlesen          ##"
  echo "##                                                        ##"
  echo "##  Gern können Sie auch eine E-Mail senden an:           ##"
  echo "##  admin [at] teris-cooper [dot] de                      ##"
  echo "############################################################"
  echo ""
  echo "Bitte geben Sie zunächst die Serveradresse Ihres Master Server ein:"
  read main_server

  
#common_args='-aPv --delete'
#common_args='-aPv --dry-run'
common_args='-aPv'
install_rsync="apt-get -y install rsync"
www_start="service apache2 start"
www_stop="service apache2 stop"
db_start="service mysql start"
db_stop="service mysql stop"

function menu {
	clear
	echo "############################################################"
	echo "##                    Hauptmenu                           ##"
	echo "##                                                        ##"
	echo "##Installation von RSync auf dem Remote Server starten (1)##"
	echo "##MySql Syncronisation starten                         (2)##"
	echo "##Webverzeichnis Syncronisation starten                (3)##"
	echo "##E-Mail Syncronisation starten                        (4)##"
	echo "##Passwörter und Benutzerkonten Syncronisation starten (5)##"
	echo "##MailMan Syncronisation starten                       (6)##"
	echo "##Programm beenden                                     (0)##"
	echo "############################################################"
	read -n 1 eingabe
}

function install {
	clear
	echo "Installation von Rsync auf dem Remote Server..."
	ssh $main_server "$install_rsync"
	echo "Ending"
	menu
}

function db_migration {
	clear
  echo "############################################################"
  echo "############################################################"
  echo "##############Starte MySql Migration           #############"
  echo "##############Step1:                           #############"
  echo "##############Erstelle Backup auf Remot Server #############"
  echo "############################################################"
  echo "##############Step2:                           #############"
  echo "##############MySql Datenbank Kopieren         #############"
  echo "############################################################"
  echo "#############Step3:                            #############"
  echo "#############MySql Datenabnk einspielen        #############"
  echo "############################################################"
  echo "############################################################"
  echo " "
  echo "Erstelle Datenbank Backup................................................................"
  echo "Bitte geben Sie das MySql-Passwort für den Benutzer ROOT auf dem Server $main_server ein:"
  read mysqlext
  ssh $main_server "mysqldump -u root -p$mysqlext --all-databases > fulldump.sql"
  clear
  echo "Kopieren des Backups....................................................................."
  rsync $common_args $main_server:/root/mysql/ /root/mysql/
  clear
  echo "Backup einspielen........................................................................"
  echo "Bitte geben Sie das MySql-Passwort für den Benuter ROOT ein:............................."
  mysql -u root -p$mysql2 < /root/mysql/fulldump.sql
  clear
  echo "Führe MySql Check durch.................................................................."
  mysqlcheck -p -A --auto-repair
  echo "############################################################"
  echo "############################################################"
  menu
}

function www_migration {
	clear

  echo "############################################################"
  echo "############################################################"
  echo "##################Starte Web Migartion######################"
  echo "##################Step1:                  ##################"
  echo "##################Stoppen des Webservers  ##################"
  echo "############################################################"
  echo "##################Step2:                  ##################"
  echo "##################Migartion Starten       ##################"
  echo "############################################################"
  $www_stop
  rsync $common_args --compress --delete $main_server:/var/www/ /var/www
  rsync $common_args --compress --delete $main_server:/var/log/ispconfig/httpd/ /var/log/ispconfig/httpd
  $www_start
  echo "############################################################"
  echo "############################################################"
  menu
}
 
function mail_migration {
	clear
  echo "---- Starting Mail migration..."
  echo "############################################################"
  echo "############################################################"
  echo "##################Starte Mail Migartion   ##################"
  echo "##################Step1:                  ##################"
  echo "##################Migration vmail         ##################"
  echo "############################################################"
  echo "##################Step2:                  ##################"
  echo "##################Migartion vmail Logs    ##################"
  echo "############################################################"
  rsync $common_args --compress --delete $main_server:/var/vmail/ /var/vmail
  rsync $common_args --compress --delete $main_server:/var/log/mail.* /var/log/
  echo "############################################################"
  echo "############################################################"
  menu
}

function files_migration {
	clear
  echo "############################################################"
  echo "############################################################"
  echo "#############Starte Benutzer und Gruppen migration   #######"
  echo "#############Step1:                                  #######"
  echo "#############Kopiere Backup                          #######"
  echo "############################################################"
  echo "#############Step2:                                  #######"
  echo "#############Kopiere Passwd in /root/old-server      #######"
  echo "############################################################"
  echo "#############Step3:                                  #######"
  echo "#############Kopiere group in /root/old-server       #######"
  echo "############################################################"
  echo "#############Bitte Manuel migriren                   #######"
  echo "#############mehr auf http://wiki.teris-cooper.de    #######"
  echo "############################################################"
  rsync $common_args $main_server:/var/backup/ /var/backup
  rsync $common_args $main_server:/etc/passwd /root/old-server/
  rsync $common_args $main_server:/etc/group  /root/old-server/
  echo "############################################################"
  echo "############################################################"
  menu
}

function mailman_migration {
	clear
  echo "############################################################"
  echo "############################################################"
  echo "############Starte Mailman migration           #############"
  echo "############################################################"
  rsync $common_args --compress --delete $main_server:/var/lib/mailman/lists /var/lib/mailman
  rsync $common_args --compress --delete $main_server:/var/lib/mailman/data /var/lib/mailman
  rsync $common_args --compress --delete $main_server:/var/lib/mailman/archives /var/lib/mailman
  cd /var/lib/mailman/bin && ./genaliases
  echo "############################################################"
  echo "############################################################"
  menu
}
function beenden {
		clear
		exit
}
menu
while [ $eingabe != "0" ]
do
case $eingabe in
        0) beenden
		    ;;
        1) install
            ;;
        2) db_migration
            ;;
        3) www_migration
            ;;
		4) mail_migration
			;;
		5) files_migration
			;;
		6) mailman_migration
			;;
esac	
done
