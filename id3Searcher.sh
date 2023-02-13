#!/bin/bash

################################################################################
#                                  id3Searcher                                 #
#                                                                              #
# Simple script searching for id3 in version 3+ and displaying these files.    #
#                                        	       			       #
#                                                                              #
# Change History                                                               #
# 04/05/2022  Maciej Szefler  Added header, help and version control.          #
#         								       #	  
# 02/05/2022  Maciej Szefler  Added main functionality, searching, copying     #
#			      found files to directory.	     		       #	
#                                                                              #
# 31/04/2022  Maciej Szefler  Created template with zenity windows.            #
#                                                                              #
################################################################################
################################################################################
################################################################################
#                                                                              #
#  Copyright (C) 2022 Maciej Szefler                                           #
#  ma.szefler@gmail.com                                                        #
#                                                                              #
#  This program is free software; you can redistribute it and/or modify        #
#  it under the terms of the GNU General Public License as published by        #
#  the Free Software Foundation; either version 2 of the License, or           #
#  (at your option) any later version.                                         #
#                                                                              #
#  This program is distributed in the hope that it will be useful,             #
#  but WITHOUT ANY WARRANTY; without even the implied warranty of              #
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the               #
#  GNU General Public License for more details.                                #
#                                                                              #
#  You should have received a copy of the GNU General Public License           #
#  along with this program; if not, write to the Free Software                 #
#  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA   #
#                                                                              #
################################################################################
################################################################################
################################################################################

################################################################################
# pomoc                                                                        #
################################################################################

pomoc() 
{
echo
echo "Syntax: id3Searcher.sh  [-h|v|a|s]"
echo "options:"
echo "h	Print this Help."
echo "v 	Print software version."
echo "a 	Print author of this script."
echo "s 	Start searching for a file with this script."
echo
echo "Directory with copied files will be shown in ./home"
echo
}


QUIT=1
while getopts "hvas" OPT; do #while loop for handling starting options
	case $OPT in
		h) pomoc #--help
		exit;;
		v) #--version
		echo
		echo "id3Searcher: version 1.0.1"
		echo
		exit;;
		a) #--author
		echo
		echo "id3Searcher: author Maciej Szefler"
		echo
		exit;;
		s) QUIT=0;; #--start program
		\?) echo "ERROR: Invalid option" #else
		exit;;
	esac
done
if [ $QUIT -ne 1 ]; then #only if user wants to start script, display zenity
	zenity --info --title "Szukacz muzyki" --text "Witaj w aplikacji wyszukujacej" --width=250
	INSTALL=$(eval pip install --user eyeD3 eyeD3[display-plugin]) #installing eyeD3 package which helps to find files with certain tags
	echo $INSTALL
fi
while [ $QUIT -ne 1 ] #main loop
do   
	menu=("1. Katalog: $KATALOG"
	  "2. Tytul: $TYTUL"
	  "3. Artysta: $ARTYSTA"
	  "4. Album: $ALBUM"
	  "5. Data publikacji: $DATA"
	  "6. Gatunek muzyki: $RODZAJ"
	  "7. Szukaj"
	  "8. Koniec")
	odp=`zenity --list --column=Menu "${menu[@]}" --height 330 --width 350`
	case $odp in
		${menu[0]}) #user chose to change directory of file
			KATALOG=`zenity --entry --title "Szukacz muzyki" --text "Podaj nazwe katalogu:"`
			if [ -n "$KATALOG" ]; then
	      			KATALOG_SZ=$KATALOG
	      		else
	      			KATALOG_SZ=""
	      		fi
			;;
		${menu[1]}) #user chose to change title of file
			TYTUL=`zenity --entry --title "Szukacz muzyki" --text "Podaj tytul muzyki:"`
			if [ -n "$TYTUL" ]; then
	      			TYTUL_SZ=$TYTUL
	      		else
	      			TYTUL_SZ=""
	      		fi
			;;
		${menu[2]}) #user chose to change artist of file
			ARTYSTA=`zenity --entry --title "Szukacz muzyki" --text "Podaj artyste:"`
			if [ -n "$ARTYSTA" ]; then
	      			ARTYSTA_SZ=$ARTYSTA
	      		else
	      			ARTYSTA_SZ=""
	      		fi
			;;
		${menu[3]}) #user chose to change directory of file
			ALBUM=`zenity --entry --title "Szukacz muzyki" --text "Podaj nazwe albumu:"`
			if [ -n "$ALBUM" ]; then
	      			ALBUM_SZ=$ALBUM
	      		else
	      			ALBUM_SZ="*"
	      		fi
			;;
		${menu[4]}) #user chose to change date of recording of file
			DATA=`zenity --entry --title "Szukacz muzyki" --text "Podaj date wypuszczenia muzyki:"`
			if [ -n "$DATA" ]; then
	      			DATA_SZ=$DATA
	      		else
	      			DATA_SZ=""
	      		fi
			;;
		${menu[5]}) #user chose to change genre of file
			RODZAJ=`zenity --entry --title "Szukacz muzyki" --text "Podaj gatunek muzyczny:"`
			if [ -n "$RODZAJ" ]; then
	      			RODZAJ_SZ=$RODZAJ
	      		else
	      			RODZAJ_SZ=""
	      		fi
			;;
		${menu[6]}) #user chose to search for a files
			TMP1=/tmp/tymczasowy.$$ #creating temporary txt files to use in next operations
			TMP2=/tmp/tymczasowy2.$$	
			WYNIK=$(eval find $KATALOG_SZ -type f -name '*mp3'  > $TMP1) #finding every mp3 file (in directory)
			cat $TMP1 | while read LINIA || [[ -n $LINIA ]];
			do
				#with grep finding recording date of file
				ROK=$(eval eyeD3 \'$LINIA\' | grep "recording date" | cut -d ' ' -f 3) 
				#with eyeD3 and display-plugin, getting title, autor, album and genre of file
				DANE=$(eval eyeD3 \'$LINIA\' -P display -p \"\<%t%+%a%+%A%+%G%+\")
				#lastly connecting found id3 tags with path to the file
				echo $LINIA $DANE$ROK">" >> $TMP2
			done
			KOMENDA=
			if [ -n "$TYTUL" ]; then #adding to command options only if user decided so
	      			KOMENDA+=$TYTUL
	      		fi
	      		if [ -n "$ARTYSTA" ]; then
	      			if [ -n "$KOMENDA" ]; then
	      				KOMENDA+="\\|"$ARTYSTA
	      			else
	      				KOMENDA=$ARTYSTA
	      			fi
	      		fi
	      		if [ -n "$ALBUM" ]; then
	      			if [ -n "$KOMENDA" ]; then
	      				KOMENDA+="\\|"$ALBUM
	      			else
	      				KOMENDA=$ALBUM
	      			fi
	      		fi
	      		if [ -n "$DATA" ]; then
	      			if [ -n "$KOMENDA" ]; then
	      				KOMENDA+="\\|"$DATA
	      			else
	      				KOMENDA=$DATA
	      			fi
	      		fi
	      		if [ -n "$RODZAJ" ]; then
	      			if [ -n "$KOMENDA" ]; then
	      				KOMENDA+="\\|"$RODZAJ
	      			else
	      				KOMENDA=$RODZAJ
	      			fi
	      		fi
	      		if [ -n "$KOMENDA" ]; then #checking if command is not empty
	      			#if is not than display files with user options 
	      			$(eval grep '$KOMENDA' $TMP2 | cut -d "<" -f 1 -> $TMP1)
	      			$(eval cat $TMP1 | \zenity --text-info --height 500 --width 800 –title \"Lista plikow\")
	      		else #if is empty, than display ALL mp3 files
	      			$(eval cat $TMP1 | \zenity --text-info --height 500 --width 800 –title \"Lista plikow\")
	      		fi
	      		if zenity --question --title "Szukacz muzyki" --text "Czy chcesz skopiowac wyszukane pliki do folderu? Uwaga, wymaga permisji administratora." --height 150 --width 350; then
	      			#if user wants to copy all files to directory than
	      			#creating directory 
	      			mkdir -p /tmp/Skopiowane;
	      			#removing every thrash from it (used if user searched more than once)
	      			rm -rf /tmp/Skopiowane/*	      			
      				cat $TMP1 | while read LINIA || [[ -n $LINIA ]];
				do
					#copying all files to the directory
					cp "$LINIA" "/tmp/Skopiowane"
				done  
				echo "Skopiowane pliki z folderem znajduja sie w katalogu /tmp/Skopiowane"
				#showing directory with copied files in nautilus
				echo $(eval nautilus --browser /tmp/Skopiowane)	
	      		fi
	      		#lastly removing temporary txt's	      		
	      		rm $TMP1 | rm $TMP2
			;;
		${menu[7]}) #if user chose to quit from script		
			if zenity --question --text="Czy usunac pakiety po uzyciu skryptu" --width=250; then
				#if user wants to delete packages after using the script, 
				#than uninstalling eyeD3 and grako (display-plugin)
				UNINSTALL=$(eval pip uninstall -y eyed3 grako)
				#checking if directory with copied files exists
				if [[ -d /tmp/Skopiowane/ ]]
				then
					#if so, than removing it
					rm -rf /tmp/Skopiowane/
				fi
				echo $UNINSTALL
				QUIT=1
			fi
			QUIT=1
			;;	
	esac
done
