#!/bin/sh
# Export each TikZ figure to a standalone, Illustrator-editable SVG.
#
# Each figure in sections/fig-*.tex is compiled on its own with the standalone
# class, then converted with dvisvgm using --no-fonts so that text becomes real
# SVG paths rather than references to embedded fonts. The result opens in
# Illustrator, Inkscape, or Figma with every element selectable.
#
# Run from the repository root:
#   docker run --rm -v "$PWD:/w" -w /w texlive/texlive:latest sh figures/build-svg.sh
#
# Output lands in figures/svg/.

set -e
OUT=figures/svg
mkdir -p "$OUT"

for f in sections/fig-*.tex; do
  name=$(basename "$f" .tex)
  echo "building $name"

  # Standalone preamble.
  cat > "$OUT/$name.tex" <<'PREAMBLE'
\documentclass[border=4pt,dvisvgm]{standalone}
\usepackage{tikz}
\usetikzlibrary{arrows.meta,positioning,shapes.geometric,fit,calc,backgrounds}
\begin{document}
PREAMBLE

  # Keep only the picture itself, dropping the float wrapper and caption.
  sed -n '/\\begin{tikzpicture}/,/\\end{tikzpicture}/p' "$f" >> "$OUT/$name.tex"

  cat >> "$OUT/$name.tex" <<'POSTAMBLE'
\end{document}
POSTAMBLE

  ( cd "$OUT" && latex -interaction=nonstopmode "$name.tex" >/dev/null 2>&1 || true )

  if [ -f "$OUT/$name.dvi" ]; then
    dvisvgm --no-fonts --exact --output="$OUT/$name.svg" "$OUT/$name.dvi" >/dev/null 2>&1
    echo "  -> $OUT/$name.svg"
  else
    echo "  !! $name failed; see $OUT/$name.log"
  fi

  rm -f "$OUT/$name.aux" "$OUT/$name.dvi"
done

echo "done. SVGs in $OUT/"
