# convert refs.bib to utf-8
iconv -f windows-1252 -t utf-8 < refs.bib > refs-utf8.bib

# add title block
echo -e "---\ntitle: Semantic Audio Tools for Radio Production\nsubtitle: PhD thesis, University of Surrey\nauthor: Chris Baume\ndate: 2018\n---\n" > main.md

# convert tex to md
/Users/chrisbau/.local/bin/pandoc \
  main.tex \
  --from latex+raw_tex \
  --to markdown \
  >> main.md

# space list of figures/tables
perl -0777 -i.original -pe 's/\\listoffigures\n\\listoftables/\[\]: spacer\n\\listoffigures\n\[\]: spacer\n\\listoftables\n\[\]: spacer\n/igs' main.md

# replace latex references with markdown
perl -0777 -i.original -pe 's/\\ref\{(.*?)\}/\[-@\1\]/igs' main.md

# remove all \-
perl -0777 -i.original -pe 's/\\-//igs' main.md

# replace fbox with code block
perl -0777 -i.original -pe 's/\\fbox\{.*?\n([\w\W]*?)\}\}/~~~\n\1\n~~~/igs' main.md

# replace paragraphs with bold writing
perl -0777 -i.original -pe 's/##### (.*?)\n\n/\*\*\1\*\* /igs' main.md

# replace tab: with tbl:
perl -0777 -i.original -pe 's/tab:/tbl:/igs' main.md

# replace \textsterling with £
perl -0777 -i.original -pe 's/\\textsterling/£/igs' main.md

# replace tikz plots with .svg figure
perl -0777 -i.original -pe 's/\\begin\{tikzpicture\}[\w\W]*?\\end\{tikzpicture\}/"!\[\]\(plots\/main-figure".$i++.".svg\)\n"/ige' main.md

#perl -0777 -i.original -pe 's/\[\\\[((fig|eq):.*?)\\\]\]\(.*?\)\{[\s\S]*?\}/\[-@\1\]/igs' main.md
#perl -0777 -i.original -pe 's/\[\\\[tab:(.*?)\\\]\]\(.*?\)\{[\s\S]*?\}/\[-\@tbl:\1\]/igs' main.md

# fix incorrect figure, equation and table markdown
perl -0777 -i.original -pe 's/\[\]\{label="(fig:.+?)"\}\]\((.+?)\)\{[\s\S]*?\}/\]\(\2\)\{#\1\}/igs' main.md
perl -0777 -i.original -pe 's/\\label\{(eq:.*?)\}\\end\{aligned\}\$\$/ \\end\{aligned\}\$\$ \{#\1\}/igs' main.md
perl -0777 -i.original -pe 's/\[\]\{label=\"tab:(.*?)\"\}/ \{#tbl:\1\}/igs' main.md

# convert md to html
/Users/chrisbau/.local/bin/pandoc \
	main.md \
  --filter pandoc-crossref \
  --filter pandoc-citeproc \
  --filter pandoc-sidenote \
  --standalone \
  --mathjax \
	--section-divs \
  --toc \
  --toc-depth=2 \
	--to html5 \
	--template=tufte-pandoc-css/tufte \
	--css tufte-css/tufte.css \
	--css tufte-pandoc-css/pandoc.css \
	--css tufte-pandoc-css/pandoc-solarized.css \
	--css tufte-pandoc-css/tufte-extra.css \
	--bibliography=refs-utf8.bib \
	--default-image-extension=svg \
  -M link-citations \
  -M reference-section-title=Bibliography \
  -M xnos-number-sections=On \
  -M numberSections \
  -M chapters \
  -M chaptersDepth=4 \
  -M linkReferences \
  | sed -e 's/figs\/print\//figs\//g' \
  | sed -e 's/figs\//figs\/web\//g' \
  | sed -e 's/=15pt =1 //' \
  | sed -E 's/, ([0-9]+), ([0-9]+)\)/, pp. \1-\2\)/g' \
  | sed -E 's/, ([0-9]+)\)/, p. \1\)/g' \
  | sed -E 's/<pre><code>/<pre class=\"code fullwidth\">/g' \
  | sed -E 's/<\/code><\/pre>/<\/pre>/g' \
  > main.html

  #| sed -E 's/<figcaption>/<span class=\"marginnote\">/g' \
  #| sed -E 's/<\/figcaption>/<\/span>/g' \
