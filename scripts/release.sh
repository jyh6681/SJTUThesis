#!/usr/bin/env sh

# This script is used for creating CTAN archive of sjtuthesis.

JOB_NAME=sjtuthesis
WORKING_DIR=$PWD
VERSION=$(git describe --tags)

# Copy all the files to system temp folder, in order to use
# chmod correctly.
TEMP_DIR=/tmp/$JOB_NAME

TDS_DIR=$TEMP_DIR/TDS
CTAN_DIR=$TEMP_DIR/$JOB_NAME

SRC_DIR=$TDS_DIR/source/latex/$JOB_NAME
TEX_DIR=$TDS_DIR/tex/latex/$JOB_NAME
DOC_DIR=$TDS_DIR/doc/latex/$JOB_NAME

LOGO_DIR=$WORKING_DIR/logos
RELEASE_DIR=$WORKING_DIR/release
OUTPUT_DIR=$RELEASE_DIR/$JOB_NAME-$VERSION

if [ -d $RELEASE_DIR ]; then
  rm -rf $RELEASE_DIR
fi

mkdir -p $TEMP_DIR

mkdir -p $TDS_DIR
mkdir -p $CTAN_DIR
mkdir -p $RELEASE_DIR
cp -r $WORKING_DIR/sample               $OUTPUT_DIR

mkdir -p $SRC_DIR
mkdir -p $TEX_DIR
mkdir -p $DOC_DIR

cp $WORKING_DIR/source/$JOB_NAME.dtx    $TEMP_DIR/
cp $WORKING_DIR/source/latexmkrc        $TEMP_DIR/
cp $WORKING_DIR/sample/thesis.tex       $TEMP_DIR/
cp $LOGO_DIR/sjtu-badge.pdf             $TEMP_DIR/
cp $LOGO_DIR/sjtu-logo.pdf              $TEMP_DIR/
cp $LOGO_DIR/sjtu-name.pdf              $TEMP_DIR/

cd $TEMP_DIR
xetex --interaction=batchmode $JOB_NAME.dtx >/dev/null
latexmk -silent $JOB_NAME.dtx     >/dev/null
latexmk -silent -c $JOB_NAME.dtx  >/dev/null

# All files should be rw-r--r--
chmod 644 $TEMP_DIR/*.*

cp $TEMP_DIR/*.dtx                      $SRC_DIR/
cp $TEMP_DIR/*.ins                      $SRC_DIR/
cp $TEMP_DIR/sjtudoc.cls                $SRC_DIR/

cp $TEMP_DIR/$JOB_NAME.cls              $TEX_DIR/
cp $TEMP_DIR/*.ltx                      $TEX_DIR/

# These files should not be put in doc/
cp $TEMP_DIR/sjtu-badge.pdf             $TEX_DIR/
cp $TEMP_DIR/sjtu-logo.pdf              $TEX_DIR/
cp $TEMP_DIR/sjtu-name.pdf              $TEX_DIR/

cp $TEMP_DIR/$JOB_NAME.pdf              $DOC_DIR/
cp $TEMP_DIR/$JOB_NAME.pdf              $RELEASE_DIR/

# Overleaf
cp $TEX_DIR/*.*                         $OUTPUT_DIR/
cp $(kpsewhich gb7714-2015.bbx)         $OUTPUT_DIR/
cp $(kpsewhich gb7714-2015.cbx)         $OUTPUT_DIR/

# Make Overleaf zip
cd $RELEASE_DIR
zip -q -r -9 $JOB_NAME-overleaf-v$VERSION.zip $JOB_NAME-$VERSION

rm $OUTPUT_DIR/gb7714-2015.*
cp $WORKING_DIR/source/latexmkrc        $OUTPUT_DIR/.latexmkrc
cp $WORKING_DIR/source/sample.mak       $OUTPUT_DIR/Makefile
cp $WORKING_DIR/source/sample.bat       $OUTPUT_DIR/compile.bat

zip -q -r -9 $JOB_NAME-v$VERSION.zip    $JOB_NAME-$VERSION

# Make TDS zip
cd $TDS_DIR
zip -q -r -9 $JOB_NAME.tds.zip .

cp $TEMP_DIR/*.dtx $CTAN_DIR
cp $TEMP_DIR/*.pdf $CTAN_DIR

rm $TEMP_DIR/*.*
cp $TDS_DIR/*.zip $TEMP_DIR
rm -r $TDS_DIR

# Make CTAN zip
cd $TEMP_DIR
zip -q -r -9 $JOB_NAME.zip .

cd $WORKING_DIR
cp -f $TEMP_DIR/*.zip                   $RELEASE_DIR/

rm -r $TEMP_DIR
rm -r $OUTPUT_DIR
