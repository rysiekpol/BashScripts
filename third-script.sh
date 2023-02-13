#!/bin/bash
QUIT=0

zenity --info --title "Szukacz" --text "Witaj w aplikacji wyszukujacej pliki" --width=250
  
while [ $QUIT -ne 1 ]
do   
	menu=("1. Nazwa pliku: $NAZWA"
	  "2. Katalog: $KATALOG"
	  "3. Czas ostatniej modyfikacji mniejszy niz: $CZAS_M"
	  "4. Czas ostatniej modyfikacji wiekszy niz: $CZAS_W"
	  "5. Rozmiar pliku w KB mniejszy niz: $ROZMIAR_M"
	  "6. Zawartość pliku: $ZAWARTOSC"
	  "7. Szukaj"
	  "8. Koniec")
	odp=`zenity --list --column=Menu "${menu[@]}" --height 330 --width 350`
	case $odp in
		${menu[0]}) 
			NAZWA=$(zenity --entry --title "Szukacz" --text "Podaj nazwe pliku")
			if [ -n "$NAZWA" ]; then
	      			NAZWA_SZ="-name '$NAZWA'"
	      		else
	      			NAZWA_SZ=""
	      		fi
			;;
		${menu[1]}) 
			KATALOG=`zenity --entry --title "Szukacz" --text "Podaj nazwe katalogu"`
			if [ -n "$KATALOG" ]; then
	      			KATALOG_SZ=$KATALOG
	      		else
	      			KATALOG_SZ=""
	      		fi
			;;
		${menu[2]}) 
			CZAS_M=`zenity --entry --title "Szukacz" --text "Podaj czas modyfikacji (minuty) mniejszy niz"`
			if [ -n "$CZAS_M" ]; then
	      			CZAS_M_SZ="-mmin -$CZAS_M"
	      		else
	      			CZAS_M_SZ=""
	      		fi
			;;
		${menu[3]}) 
			CZAS_W=`zenity --entry --title "Szukacz" --text "Podaj czas modyfikacji (minuty) wiekszy niz"`
			if [ -n "$CZAS_W" ]; then
	      			CZAS_W_SZ="-mmin +$CZAS_W"
	      		else
	      			CZAS_W_SZ=""
	      		fi
			;;
		${menu[4]}) 
			ROZMIAR_M=`zenity --entry --title "Szukacz" --text "Podaj rozmiar pliku [KB] mniejszy niz:"`
			if [ -n "$ROZMIAR_M" ]; then
	      			ROZMIAR_M_SZ="-size -${ROZMIAR_M}k" 
	      		else
	      			ROZMIAR_M_SZ=""
	      		fi
			;;
		${menu[5]}) 
			ZAWARTOSC=`zenity --entry --title "Szukacz" --text "Podaj zawartosc pliku"`
			if [ -n "$ZAWARTOSC" ]; then
	      			ZAWARTOSC_SZ="-exec grep -l '$ZAWARTOSC' {} \;" 
	      		else
	      			ZAWARTOSC_SZ=""
	      		fi
			;;
		${menu[6]}) 
			WYNIK=$(eval find $KATALOG_SZ -type f $NAZWA_SZ $CZAS_M_SZ $CZAS_W_SZ $ROZMIAR_M_SZ $ZAWARTOSC_SZ | \zenity --text-info –height 200 –title \"Lista plikow\")
			echo $WYNIK
			;;
		${menu[7]}) 
			QUIT=1
			;;	
	esac
done






