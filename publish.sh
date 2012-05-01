#!/bin/bash

[ $# -lt 2 ] && echo "Usage $0 <ascii-doc-file> <destination-dir> [title.suffix]" && exit 1
FILE=$1
DIR=$2
mkdir -p $DIR
[ ! -d $DIR ] && echo "Failed to create $DIR" && exit 2
mkdir -p $DIR/images
mkdir -p $DIR/screens

attrs=()

attrs+=("-a icons")
attrs+=("-a toc")
attrs+=("-a numbered")

if [ $# -eq 3 ]; then
    attrs+=("-a title_suffix=\"for $3\"")
fi

eval asciidoc ${attrs[@]} -o $DIR/index.html $ASCII_DOC_ATTRS $FILE


FILES=`grep -o -E '<img src="([^"]+)"' $DIR/index.html | grep -v http | grep -o -E '(screens|images)/[^"]+' | sort -u`
for FILE in $FILES ; do
  mkdir -p $DIR/`dirname $FILE`
  cp $FILE $DIR/$FILE
done

FILES=`grep -o -E '<a href="([^"]+)"' $DIR/index.html | grep -v http | grep -o -E '(examples?|code|labs?)/[^"]+' | sort -u`
for FILE in $FILES ; do
  cp -r `dirname $FILE` $DIR/`dirname $FILE`
done

