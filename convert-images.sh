while read line; do pdf2svg figs/$line figs/web/`basename $line .pdf`.svg; done < figs/web/images-to-convert.txt
for i in figs/web/*.svg; do perl -0777 -i.original -pe 's/fill-opacity:1;stroke:none/fill-opacity:0;stroke:none/igs' $i; done
for i in plots/*.pdf; do pdf2svg $i `basename $i .pdf`.svg; done
