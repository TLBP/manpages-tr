#!/bin/sh
#
LANG=C gcc -Wall -lz -o xml2man xml2man.c
mandirs=(1 2 3 4 5 6 7 8)
for i in ${mandirs[@]};
do
    mkdir ../tr/man$i;
  for j in man$i/*;
  do
    manfile=`basename $j .$i.xml`;
    echo man$i/$manfile.$i derleniyor;
    target="../tr/man$i/$manfile.$i";
    if [ "$1" == "--debianize" ]
    then
        ./xml2man $1 $j > ${target}.$1; 
	iconv -f UTF-8 -t ISO-8859-9 ${target}.$1 > $target;
	rm -f ${target}.$1;   
    elif [ "$1" == "--utf8" ]
    then
	./xml2man $1 $j > $target;
    else
        ./xml2man $j > $target; 
    fi
  done 
  if [ "$1" != "--debianize" ] && [ -d tr/man$i ] 
  then
	cp tr/man$i/* ../tr/man$i/
  fi
  gzip -9 ../tr/man$i/*;
done
