#!/bin/bash
assignment=$1
dest=teacher/assignments/$1
mkdir -p $dest
for f in teacher/solutions/$1/*; do 
  echo $f
  F=$(basename $f)
  d=${f#teacher/solutions/$1/}
  d=${d/-solutions.ipynb/.ipynb}
  destfile=$dest/$d
  if [[ "$F" == assign* ]]; then
    echo Processing $f
    bin/removeSolutions.py $f $destfile
  else
    rsync -aug $f $destfile
  fi

done
