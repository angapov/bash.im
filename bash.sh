#!/bin/bash
echo "DROP TABLE IF EXISTS quotes;" | mysql -uroot -pdfybkmyfzufptkm2013 bash;
echo "CREATE TABLE quotes (id INT(8), date DATE, rating INT(8), text MEDIUMTEXT);" | mysql -uroot -pdfybkmyfzufptkm2013 bash;
for PAGE_NUM in `seq 1 988`; do
  elinks -dump -dump-width 150 http://bash.im/index/$PAGE_NUM > BASH
  sed = BASH | sed -nr -e 'N;s/\n//' -e 's%\[[0-9]{1,3}\]\+ ([0-9]{1,6}) \[[0-9]{1,3}\].*([0-9]{4}\-[0-9]{2}\-[0-9]{2}).*#([0-9]{1,6})%\1 \2 \3%p' > INDEX 
  LINES=$(wc -l INDEX | cut -d' ' -f1)
  LINE1=$((PAGE_NUM-1)); LINE2=$((PAGE_NUM-2))
  LAST_LINE=$(grep -nEo "$LINE1.*$LINE2.*начало" BASH | cut -d: -f1 | tail -n1)
  for i in `seq $LINES`; do
    j=$((i+1))
    read CURR_LINE QUOTE_RATING QUOTE_DATE QUOTE_NUM <<< $(sed -n "${i}p" INDEX)  
    ((CURR_LINE++))
    if [ $i -ne $LINES ]; then NEXT_LINE=`sed -n "${j}p" INDEX | cut -d' ' -f1`; else NEXT_LINE=$LAST_LINE; fi
    ((NEXT_LINE--))
    QUOTE_TEXT="$(sed -n "${CURR_LINE},${NEXT_LINE}p" BASH | sed 's%\\%\\\\%g' | sed "s%'%\\\\\'%g")"
    echo "INSERT INTO quotes (id,date,rating,text) VALUES ('$QUOTE_NUM', '$QUOTE_DATE', '$QUOTE_RATING', '$QUOTE_TEXT');" | mysql -uroot -pdfybkmyfzufptkm2013 bash;
  done
done
