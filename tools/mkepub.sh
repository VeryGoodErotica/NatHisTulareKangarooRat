#!/bin/bash

CWD=`pwd`

TMP=`mktemp -d /tmp/NATKG.XXXXXXXX`

pushd ${TMP}

git clone https://github.com/VeryGoodErotica/NatHisTulareKangarooRat.git

cd NatHisTulareKangarooRat/TheArticle/EPUB

# testing alternate css
#cat css/noitalics.css >> css/a11y.css

[ -f ~/PipfroschPressLogo/NewPipfroschPress5.png ] && cp ~/PipfroschPressLogo/NewPipfroschPress5.png auximg/
python3 ../../tools/updateTimestamp.py content.opf
cd fonts
rm -f .gitignore
cp -p /usr/local/ePubFonts/ClearSans-BoldItalic-wlatin.ttf .
cp -p /usr/local/ePubFonts/ClearSans-Bold-wlatin.ttf .
cp -p /usr/local/ePubFonts/ClearSans-Italic-wlatin.ttf .
cp -p /usr/local/ePubFonts/ClearSans-Regular-wlatin.ttf .
cp -p /usr/local/ePubFonts/Averia-Bold-wlatin.ttf .
cp -p /usr/local/ePubFonts/Averia-Regular-wlatin.ttf .
cd ../..

echo -n application/epub+zip >mimetype

zip -r -X Book.zip mimetype META-INF EPUB
mv Book.zip NaturalHistoryOfTheTulareKangarooRat.epub


sh ../tools/epubcheck.sh NaturalHistoryOfTheTulareKangarooRat.epub

if hash ace 2>/dev/null; then
  if [ ! -f ${CWD}/AceReport/noace.tmp ]; then
    ace -f -s -o AceReport NaturalHistoryOfTheTulareKangarooRat.epub
    rm -rf ${CWD}/AceReport/data
    [ ! -d ${CWD}/AceReport ] && mkdir ${CWD}/AceReport
    mv AceReport/data ${CWD}/AceReport/
    mv AceReport/report.html ${CWD}/AceReport/
    mv AceReport/report.json ${CWD}/AceReport/
    echo "Accessibility report written to AceReport directory"
    echo `pwd`
  fi
fi


mv NaturalHistoryOfTheTulareKangarooRat.epub ${CWD}/

popd

if hash ace 2>/dev/null; then
  if [ -f AceReport/.gitignore ]; then
    if [ ! -f AceReport/noace.tmp ]; then
      git commit -m "update AceReport" AceReport/report.*
    fi
  fi
fi

rm -rf ${TMP}

exit 0
