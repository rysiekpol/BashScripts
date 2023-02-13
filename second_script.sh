#!/bin/bash
QUIT=0

while [ $QUIT -ne 1 ]
do
  echo "1. Nazwa pliku: $NAZWA"
  echo "2. Katalog: $KATALOG"
  echo "3. Czas ostatniej modyfikacji mniejszy niz: $CZAS_M"
  echo "4. Czas ostatniej modyfikacji wiekszy niz: $CZAS_W"
  echo "5. Rozmiar pliku w KB mniejszy niz: $ROZMIAR_M"
  echo "6. Zawartość pliku: $ZAWARTOSC"
  echo "7. Szukaj"
  echo "8. Koniec"

  read OPTION
  clear
  case $OPTION in 
    
    1)
      echo "Podaj nazwe pliku:"
      read NAZWA    
      if [ -n "$NAZWA" ]; then
      	NAZWA_SZ="-name '$NAZWA'"
      else
      	NAZWA_SZ=""
      fi
    ;;
    2)
      echo "Podaj nazwe katalogu:"
      read KATALOG
      if [ -n "$KATALOG" ]; then
      	KATALOG_SZ=$KATALOG
      else
      	KATALOG_SZ=""
      fi
    ;;
    3)
      echo "Podaj czas modyfikacji w minutach mniejszy niz:"
      read CZAS_M
      if [ -n "$CZAS_M" ]; then
      	CZAS_M_SZ="-mmin -$CZAS_M" 
      else
      	CZAS_M_SZ=""
      fi
    ;;
    4)
      echo "Podaj czas modyfikacji wiekszy w minutach niz:"
      read CZAS_W
      if [ -n "$CZAS_W" ]; then
      	CZAS_W_SZ="-mmin +$CZAS_W" 
      else
      	CZAS_W_SZ=""
      fi
    ;;
    5)
      echo "Podaj rozmiar pliku w KB mniejszy niz:"
      read ROZMIAR_M
      if [ -n "$ROZMIAR_M" ]; then
      	ROZMIAR_M_SZ="-size -${ROZMIAR_M}k" 
      else
      	ROZMIAR_M_SZ=""
      fi
    ;;
    6)
      echo "Podaj zawartosc pliku"
      read ZAWARTOSC
      echo "jesten tutaj"
      if [ -n "$ZAWARTOSC" ]; then
      	ZAWARTOSC_SZ="-exec grep -l '$ZAWARTOSC' {} \;" 
      else
      	ZAWARTOSC_SZ=""
      fi
    ;;
    7)
      echo "Wyszukuje"
      WYNIK=$(eval find $KATALOG_SZ -type f $NAZWA_SZ $CZAS_M_SZ $CZAS_W_SZ $ROZMIAR_M_SZ $ZAWARTOSC_SZ)
      echo $WYNIK | tr " " "\n"
    ;;
    8)
      echo "Koncze wykonywanie programu"
      QUIT=1
    ;;
  esac		
done







