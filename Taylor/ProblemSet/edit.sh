#!/bin/bash
cat *.xml > all.xml

#remove extra
sed -i -e '/<?xml version="1.0" encoding="UTF-8"?>/d' all.xml
sed -i -e '/<quiz>/d' all.xml
sed -i -e '/<\/quiz>/d' all.xml

#restore xml metainformation, first and last <quiz>, </quiz> groups
sed -i -e '1i<?xml version="1.0" encoding="UTF-8"?>\' all.xml
sed -i -e '2i<quiz>\' all.xml
echo '<\quiz>' >> all.xml
