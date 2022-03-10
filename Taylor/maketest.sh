#!/bin/bash
mkdir -p  ProblemSet2022
sage genData.sage >> update.txt
sage genFiles.sage >> selected.txt
rm *.py
cd ProblemSet2022/
#merge quizes files in to one xml file
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
echo '<\quiz>' >> all.xml
cd ..