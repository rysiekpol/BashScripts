#! /bin/sh
grep "OK DOWNLOAD" cdlinux.ftp.log | cut -d '"' -f 2,4 | sort -u | cut -d '"' -f 2 -> wynik

grep "GET" cdlinux.www.log | cut -d ' ' -f 1,7,9 | cut -d ':' -f 2 | grep '200\|206' | cut -d ' ' -f 1,2 | sort -u | cut -d ' ' -f 2 | sed 's.%2F./.g' -> wynik2 

cat wynik2 >> wynik

sed "s#.*/##" wynik | grep "iso$" | sort | uniq -c | sort -t ' ' -k2gr

rm wynik2 | rm wynik

