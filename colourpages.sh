#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Usage: colourpages.sh target.pdf"
else
  totalPages=`mdls -n kMDItemNumberOfPages "$1" | cut -c24-`
  bwPages=`gs -o - -sDEVICE=inkcov "$1" | grep -e ".*0\.00000  0\.00000  0\.00000  .*" | wc -l | tr -d ' '`
  colourPages=`expr $totalPages - $bwPages`
  echo -e "Pages:\t${totalPages}\nB&W:\t${bwPages}\nColour:\t${colourPages}"
fi
