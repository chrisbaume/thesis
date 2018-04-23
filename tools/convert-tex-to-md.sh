# convert refs.bib to utf-8
iconv -f windows-1252 -t utf-8 < refs.bib > refs-utf8.bib

# add title block
echo -e "---\ntitle: Semantic Audio Tools for Radio Production\nsubtitle: PhD thesis, University of Surrey\nauthor: Chris Baume\ndate: 2018\n---\n" > "$2"

# convert tex to md
/Users/chrisbau/.local/bin/pandoc \
  "$1" \
  --from latex+raw_tex \
  --to markdown \
  >> "$2"

# space list of figures/tables
perl -0777 -i.original -pe 's/\\listoffigures\n\\listoftables/\[\]: spacer\n\\listoffigures\n\[\]: spacer\n\\listoftables\n\[\]: spacer\n/igs' "$2"

# replace latex references with markdown
perl -0777 -i.original -pe 's/\\ref\{(.*?)\}/\[-@\1\]/igs' "$2"

# remove all \-
perl -0777 -i.original -pe 's/\\-//igs' "$2"

# replace fbox with code block
perl -0777 -i.original -pe 's/\\fbox\{.*?\n([\w\W]*?)\}\}/~~~\n\1\n~~~/igs' "$2"

# replace paragraphs with bold writing
perl -0777 -i.original -pe 's/##### (.*?)\n\n/\*\*\1\*\* /igs' "$2"

# replace tab: with tbl:
perl -0777 -i.original -pe 's/tab:/tbl:/igs' "$2"

# replace \textsterling with £
perl -0777 -i.original -pe 's/\\textsterling/£/igs' "$2"

# replace tikz plots with .svg figure
perl -0777 -i.original -pe 's/\\begin\{tikzpicture\}[\w\W]*?\\end\{tikzpicture\}/"!\[\]\(plots\/main-figure".$i++.".svg\)\n"/ige' "$2"

#perl -0777 -i.original -pe 's/\[\\\[((fig|eq):.*?)\\\]\]\(.*?\)\{[\s\S]*?\}/\[-@\1\]/igs' "$2"
#perl -0777 -i.original -pe 's/\[\\\[tab:(.*?)\\\]\]\(.*?\)\{[\s\S]*?\}/\[-\@tbl:\1\]/igs' "$2"

# fix incorrect figure, equation and table markdown
perl -0777 -i.original -pe 's/\[\]\{label="(fig:.+?)"\}\]\((.+?)\)\{[\s\S]*?\}/\]\(\2\)\{#\1\}/igs' "$2"
perl -0777 -i.original -pe 's/\\label\{(eq:.*?)\}\\end\{aligned\}\$\$/ \\end\{aligned\}\$\$ \{#\1\}/igs' "$2"
perl -0777 -i.original -pe 's/\[\]\{label=\"tbl:(.*?)\"\}/ \{#tbl:\1\}/igs' "$2"

