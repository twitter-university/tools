#!/bin/bash

[ $# -lt 1 ] && echo "Usage $0 <ascii-doc-file> [title.suffix]" && exit 1
FILE=$1

attrs=()
attrs+=("-v")
attrs+=("-f pdf")
attrs+=("-d book")
attrs+=("--icons")
attrs+=("--icons-dir=/opt/local/etc/asciidoc/images/icons/")
attrs+=("--dblatex-opts \"-P latex.output.revhistory=0\"")

if [ $# -eq 2 ]; then
    attrs+=("-a title_suffix=\"$3\"")
fi

eval a2x.py ${attrs[@]} $FILE

