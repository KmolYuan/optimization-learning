#!/usr/bin/env bash
# Usage:
# sh compile.sh FILE_NUMBER

BASEDIR=$(readlink -f "$(dirname "$(readlink -f "${0}")")")
if [ "${1}" == "all" ]
then
  FILE=($(ls *.md) "${BASEDIR}/group.md")
elif [ "${1}" == "g" ]
then
  FILE=("${BASEDIR}/group.md")
else
  FILE=("${BASEDIR}/homework${1}.md")
fi

if [[ "$(uname)" == "Linux" ]]
then
  FONT=ukai.ttc
  MONOFONT="DejaVu Sans Mono"
else
  FONT=DFKai-SB
  MONOFONT=Consolas
fi

for f in "${FILE[@]}"
do
  pandoc ${f} -o $(basename -- "${f%.*}").pdf -N -M link-citations=true --bibliography=refer.bib --csl=ieee.csl --pdf-engine=xelatex -V CJKmainfont="${FONT}" -V monofont="${MONOFONT}"
done
