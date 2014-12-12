#get list of genes (this can also be a single sequence, like a chloroplast)

genes=(`cat $1`)
gLen=${#genes[@]}

#get list of depth files for ecotypes
ecoDepths=(`ls *.depth`)
ecoLen=${#ecoDepths[@]}

#get array of global medians per ecotype
globalMedianList=(`cat globalMedians | awk '{print $2}'`)

for((i=0;i<$gLen;i++));do
        for((j=0;j<$ecoLen;j++));do
                grep ${genes[$i]} ${ecoDepths[$j]} > tempGeneEcoFile

                #Go through the .depth file for each ecotype and see if depth at each position in the gene exceends the cutoff.  If not, we record it.
                awk -v median=${globalMedianList[$j]} '$3 < median/10 || $3 > 5*median {print $1"\t"$2}' tempGeneEcoFile >> ${genes[$i]}.DASH
                rm tempGeneEcoFile
        done
done
