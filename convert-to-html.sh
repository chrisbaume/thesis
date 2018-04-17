# convert refs.bib to utf-8
iconv -f windows-1252 -t utf-8 < refs.bib > refs-utf8.bib

# convert tex to md
/Users/chrisbau/.local/bin/pandoc \
  main.tex \
  --from latex \
  --to markdown \
  > main.md

perl -0777 -i.original -pe 's/\[\\\[(fig:.*?)\\\]\]\(.*?\)\{[\s\S]*?\}/\[@\1\]/igs' main.md
perl -0777 -i.original -pe 's/\[\]\{label="(fig:.+?)"\}\]\((.+?)\)\{[\s\S]*?\}/\]\(\2\)\{#\1\}/igs' main.md

# convert md to html
/Users/chrisbau/.local/bin/pandoc \
	main.md \
  --filter pandoc-crossref \
  --filter pandoc-citeproc \
	--katex \
	--section-divs \
	--to html5 \
	--template=tufte-pandoc-css/tufte \
	--css tufte-css/tufte.css \
	--css tufte-pandoc-css/pandoc.css \
	--css tufte-pandoc-css/pandoc-solarized.css \
	--css tufte-pandoc-css/tufte-extra.css \
	--bibliography=refs-utf8.bib \
	--default-image-extension=png \
  -M link-citations \
  -M reference-section-title=Bibliography \
  -M xnos-number-sections=On \
  -M numberSections \
  -M chapters \
  -M chaptersDepth=4 \
  | sed -e 's/figs\/print\//figs\//g' \
  | sed -e 's/figs\//figs\/web\//g' \
  | sed -e 's/=15pt =1 //' \
  > main.html

#/Users/chrisbau/.local/bin/pandoc main.tex -F pandoc-fignos -f latex -t html -s -N --mathml --bibliography=refs-utf8.bib --default-image-extension=png -M xnos-number-sections=On
