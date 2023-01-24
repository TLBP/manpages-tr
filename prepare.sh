#! /bin/bash

src="source"
dest="tr"
mandirs=(1 2 3 4 5 6 7 8)

rm -dfr ./$dest
mkdir $dest

for i in ${mandirs[@]};
do
  mkdir $dest/man$i;
  cp $src/man$i/* $dest/man$i;
  cd $dest/man$i;

  for j in *;
  do
    content=$(cat $j);
    if [ "${content:0:3}" = ".so" ];
    then
      ln -sfT ${content:4} $j;
      content="";
    else
      gzip -9 -n $j;
    fi
  done
  cd ../..;
done

