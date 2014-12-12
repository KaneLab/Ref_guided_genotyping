ls *.depth > ecotypeList

cat ecotypeList | while read ecotype;do
        ecotypeMedian=`awk '{print $3}' $ecotype | sort -n | awk -f median.awk`
        echo "$ecotype  $ecotypeMedian" >> globalMedians
done

rm ecotypeList
