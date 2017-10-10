#!/bin/bash
#Written by Makarand Joshi on 10/10/2017

years=`seq 2001 1 2017`
pages=`seq 2 1 10`

for y in $years  #Outside loop to account for no-context-root first page
  do
    curl -s https://www.entrepreneur.com/franchise500/$y >> "source"$y".txt" #| grep -i franchise-list-item | cut -f3 -d"/" >> $y.txt
    echo $y"-Franchises" >> $y"firms.txt"
    grep -i franchise-list-item "source"$y".txt" | cut -f3 -d"/" >> $y"firms.txt"
    echo $y"-Investments" >> $y"money.txt"
    grep -i "span class" "source"$y".txt" | grep -i investment | cut -d">" -f 3,5,7,9 | sed 's/<\/span>/;/g' | sed 's/......$//' | sed -e 's/;//' -e 's/;/-/' -e 's/;//' >> $y"money.txt"

    for p in $pages  #Inside loop to run through the remaining 9 pages which have a context root in the URL
      do
        curl -s https://www.entrepreneur.com/franchise500/$y/$p >> "source"$y$p".txt"
        grep -i franchise-list-item "source"$y$p".txt" | cut -f3 -d"/" >> $y"firms.txt"
        grep -i "span class" "source"$y$p".txt" | grep -i investment | cut -d">" -f 3,5,7,9 | sed 's/<\/span>/;/g' | sed 's/......$//' | sed -e 's/;//' -e 's/;/-/' -e 's/;//' >> $y"money.txt"
      done
      paste -d";" $y"firms.txt" $y"money.txt" > "final"$y".txt"
  done

paste -d";" final*.txt > Franchise500-Ranking.csv   #Consolidate all data into CSV

rm source*.txt 20*.txt final*.txt  #Cleanup unnecessary files

## The End!
