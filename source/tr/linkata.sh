#!/bin/bash
# sembolik bağları yapalım

cd source/tr
ls
mandirs=(1 2 3 4 5 6 7 8)
for i in ${mandirs[@]};
do
    if [ -d man$i ]
    then
	for j in man$i/*;
	do
		#echo "linklemeye girdi"
		k=`cat $j`;
		[ -f $j ] && ln -s $k ../../tr/${j}.gz; 
		rm -f $j
	done
	rmdir man$i >& /dev/null
    fi
done