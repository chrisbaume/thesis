# convert refs.bib to utf-8
iconv -f windows-1252 -t utf-8 < refs.bib > refs-utf8.bib

# convert tex to html
pandoc main.tex -F pandoc-fignos -f latex -t html -s -N -o main.html --mathml --bibliography=refs-utf8.bib --default-image-extension=png -M xnos-number-sections=On

sed 's/figs\/print\//figs\//g' main.html > main-temp.html
sed 's/figs\//figs\/web\//g' main-temp.html > main.html
rm main-temp.html
