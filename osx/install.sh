#!/bin/bash

for src in `find . -not -path '*/\.*' -type f -mindepth 2`
do
  dest=${src#.}
  src=`pwd`$dest
  echo "Linking $dest to $src"
  if [ -f $dest -o -h $dest ]
    then sudo rm $dest
  fi
  sudo ln -s $src $dest
done

