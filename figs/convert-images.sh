while read line; do pdftocairo -png -scale-to 800 -singlefile $line web/`basename $line .pdf`; done < web/images-to-convert.txt
