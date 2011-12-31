#!/bin/sh

# Run with no arguments for description and usage information.
# This script depends on AsciiDoc, DocBook, and xsltproc

ASCIIDOC=`which asciidoc`
XSLTPROC=`which xsltproc`
ZIP=`which zip`
BASENAME=`which basename`
DIRNAME=`which dirname`
BOOKSHELF_XSL=`$DIRNAME $0`/bookshelf.xsl
OLD_TOC_FILE=bk01-toc.html
NEW_TOC_FILE=table_of_contents.html

[ ! -f "$ASCIIDOC" ] && echo "Cannot find 'asciidoc'" && exit 1
[ ! -f "$XSLTPROC" ] && echo "Cannot find 'xsltproc'" && exit 1
[ ! -f "$ZIP" ] && echo "Cannot find 'zip'" && exit 1
[ ! -f "$BASENAME" ] && echo "Cannot find 'basename'" && exit 1
[ ! -f "$DIRNAME" ] && echo "Cannot find 'dirname'" && exit 1
[ ! -f "$BOOKSHELF_XSL" ] && echo "Required file does not exist $BOOKSHELF_XSL" && exit 1

if [ $# -lt 1 ]; then
	echo "This script can be used to convert an AsciiDoc-based book into chunked-HTML files compressed in a ZIP archive."
	echo "This archive can then be uploaded to Marakana Bookshelf: http://marakana.com -> Admin -> Static Files -> bookshelf/"
	echo 
    echo "Please make sure that every AsciiDoc 2nd-level section is prefixed with an [[My_Unique_Section_Id]] as this ID becomes My_Unique_Section_Id.html chunked HTML file and gets referenced in the generated table_of_contents.html file"
    echo 
    echo "Usage $0 <book.asc> [<package.zip>]"
    exit 1
fi

BOOK_ASC=$1
if [ ! -f $BOOK_ASC ]; then
    echo "No such file exists: $BOOK_ASC"
    exit 1
fi

DOCBOOK_FILE_XML=`$BASENAME -s .asc $BOOK_ASC`.xml

if [ $# -eq 2 ]; then
    PACKAGE_ZIP=$2
else
    BOOK_ASC_DIR_NAME=`$BASENAME $PWD`
    PACKAGE_ZIP=`$BASENAME $BOOK_ASC_DIR_NAME`.zip
fi
OUT_DIR=`$BASENAME -s .zip $PACKAGE_ZIP`
if [ "$OUT_DIR" = "$PACKAGE_ZIP" ]; then
    echo "Please specify .zip extension on the <package.zip> file: $PACKAGE_ZIP"
    exit 1
fi
if [ -d $OUT_DIR ]; then
    echo "Temporary directory already exists: $OUT_DIR"
    echo "Please delete this directory and try again."
    echo "Alternatively, specify a different <package.zip> file, from which the directory name is derived: $PACKAGE_ZIP"
    exit 1
fi

echo $BOOKSHELF_XSL

echo "Converting $BOOK_ASC (AsciiDoc) to $DOCBOOK_FILE_XML (DocBook)..."
$ASCIIDOC -a format=tohtml -b docbook -o $DOCBOOK_FILE_XML $BOOK_ASC
echo "Done"

echo "Making output directory $OUT_DIR..."
mkdir -p $OUT_DIR
echo "Done"

echo "Converting $DOCBOOK_FILE_XML (DocBook) to $OUT_DIR/ (Chunked HTML)..."
$XSLTPROC -o $OUT_DIR/ --nonet $BOOKSHELF_XSL $DOCBOOK_FILE_XML
echo "Done"

IMAGES_DIR=`$DIRNAME $BOOK_ASC`/images
if [ -d $IMAGES_DIR ]; then
	if [ -d $IMAGES_DIR/.svn ]; then
		echo "Exporting $IMAGES_DIR to $OUT_DIR/images..."
		svn export $IMAGES_DIR $OUT_DIR/images
    else
		echo "Copying $IMAGES_DIR to $OUT_DIR/images..."
		cp -r $IMAGES_DIR $OUT_DIR/.
	fi
    echo "Done"
fi

CODE_DIR=`$DIRNAME $BOOK_ASC`/code
if [ -d $CODE_DIR ]; then
	if [ -d $CODE_DIR/.svn ]; then
		echo "Exporting $CODE_DIR to $OUT_DIR/code..."
		svn export $CODE_DIR $OUT_DIR/code
    else
		echo "Copying $CODE_DIR to $OUT_DIR/code..."
		cp -r $CODE_DIR $OUT_DIR/.
	fi
    echo "Done"
fi

if [ -f $OUT_DIR/$OLD_TOC_FILE ]; then	
	echo "Renaming $OUT_DIR/$OLD_TOC_FILE to $OUT_DIR/$NEW_TOC_FILE..."
    mv $OUT_DIR/$OLD_TOC_FILE $OUT_DIR/$NEW_TOC_FILE
    ls -1 $OUT_DIR/*.html | xargs sed -i '' "s/$OLD_TOC_FILE/$NEW_TOC_FILE/g"
    echo "Done"
fi

if [ -f $PACKAGE_ZIP ]; then
	echo "Deleting existing $PACKAGE_ZIP..."
	rm $PACKAGE_ZIP
    echo "Done"
fi

echo "Compressing $OUT_DIR to $PACKAGE_ZIP..."
$ZIP -r $PACKAGE_ZIP $OUT_DIR
echo "Done"

echo "Removing $OUT_DIR directory..."
rm -fr $OUT_DIR
echo "Done"

echo "Removing $DOCBOOK_FILE_XML (DocBook) file..."
rm $DOCBOOK_FILE_XML
echo "Done"
echo
echo "You are now ready to upload $PACKAGE_ZIP to marakana.com -> Admin -> Static Files -> bookshelf/"
echo "Don't forget to add/adjust a link to your /bookshelf/$OUT_DIR/index.html in marakana.com/bookshelf.html"
echo "Oh, and don't forget to tell the world about it!!!"
exit 0
