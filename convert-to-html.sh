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
  -M codeBlockCaptions \
  | sed -e 's/figs\/print\//figs\//g' \
  | sed -e 's/figs\//figs\/web\//g' \
  | sed -e 's/=15pt =1 //' \
  | sed -E 's/, ([0-9]+), ([0-9]+)\)/, pp. \1-\2\)/g' \
  | sed -E 's/, ([0-9]+)\)/, p. \1\)/g' \
  | sed -E 's/<pre><code>/<pre class=\"code fullwidth\">/g' \
  | sed -E 's/<\/code><\/pre>/<\/pre>/g' \
  > main.html
