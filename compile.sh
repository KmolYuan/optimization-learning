#!/usr/bin/env bash
i=0
for f in *.md; do
    pandoc ${f} -o $(basename -- "${f%.*}").pdf -N -M link-citations=true --bibliography=refer.bib --csl=apa.csl
    i=$((i+1))
done

echo "Compiled ${i} file(s)."
