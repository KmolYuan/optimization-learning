#!/usr/bin/env bash
# Usage:
# sh compile.sh FILE_NUMBER

BASEDIR=$(readlink -f "$(dirname "$(readlink -f "${0}")")")
FILE=${BASEDIR}/homework${1}.md
pandoc "${FILE}" -o $(basename -- "${FILE%.*}").pdf -N -M link-citations=true --bibliography=refer.bib --csl=apa.csl
