#!/bin/bash

if [ $# -ne 1 ]; then
  echo "Usage: colorpages.sh target.pdf"
else
  totalPages=`mdls -n kMDItemNumberOfPages "$1" | cut -c24-`
  bwPages=`gs -o - -sDEVICE=inkcov "$1" | grep -e ".*0\.00000  0\.00000  0\.00000  .*" | wc -l | tr -d ' '`
  colorPages=`expr $totalPages - $bwPages`
  echo -e "Pages:\t${totalPages}\nB&W:\t${bwPages}\nColor:\t${colorPages}"
fi
