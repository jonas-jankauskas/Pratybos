#!/bin/bash
mkdir -p  ProblemSet
sage genData.sage > ProblemSet/update.txt
sage genFiles.sage > ProblemSet/selected.txt
rm *.py
cd ProblemSet/
#merge quizes files in to one xml file
rm -f all.xml
cat *.xml > all.tmp
rm *.xml
mv all.tmp all.xml

#remove extra metainformation and quiz  groups
sed -i -e '/<?xml version="1.0" encoding="UTF-8"?>/d' all.xml
sed -i -e '/<quiz>/d' all.xml
sed -i -e '/<\/quiz>/d' all.xml

#restore xml metainformation, first and last <quiz>, </quiz> groups
sed -i -e '1i<?xml version="1.0" encoding="UTF-8"?>\' all.xml
sed -i -e '2i<quiz>\' all.xml
echo '</quiz>' >> all.xml
cd ..