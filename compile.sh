#!/usr/bin/env bash
# Usage:
# sh compile.sh FILE_NUMBER

BASEDIR=$(readlink -f "$(dirname "$(readlink -f "${0}")")")
if [ "${1}" == "all" ]; then
  FILE=($(ls *.md))
else
  FILE=("${BASEDIR}/homework${1}.md")
fi
for f in "${FILE[@]}"; do
  pandoc ${f} -o $(basename -- "${f%.*}").pdf -N -M link-citations=true --bibliography=refer.bib --csl=apa.csl
done
