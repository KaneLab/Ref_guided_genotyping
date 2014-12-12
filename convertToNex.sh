#Simple script to convert fasta to nexus
#infile is fasta

#nexus format looks like this

#NEXUS
#Begin data;
#Dimensions ntax=4 nchar=15;
#Format datatype=dna missing=? gap=-;
#Matrix
#Species1   atgctagctagctcg
#Species2   atgcta??tag-tag
#Species3   atgttagctag-tgg
#Species4   atgttagctag-tag           
#;
#End;

fileName=`echo $1 | sed 's/\(\.fa\|.fasta\)//g'`

#get rid of carriage returns
awk '{if($1 ~ /^>/){print $0 "QQQQ"}else{print $0}}' $1 | tr -d "\n \t" | sed 's/>/\n/g' | sed 's/QQQQ/\t/g' | sed '/^$/d' > ${fileName}.nexTemp

#count number of taxa, as the number of non whitespace lines
ntaxa=`awk '$1 ~ /^[A-Za-z0-9]/ {print $0}' ${fileName}.nexTemp | wc -l`

#count number of positions as the number of characters in the first row second column
chars=`head -n1 ${fileName}.nexTemp | awk '{print $2}'`
nchars=`echo ${#chars}`

#print stuff together, remove temp file
cat <(echo -e "#NEXUS\nBegin data;\nDimensions ntax=${ntaxa} nchar=${nchars};\nFormat datatype=dna missing=? gap=-;\nMatrix") ${fileName}.nexTemp <(echo -e "\n;\nEnd;") > ${fileName}.nex
rm ${fileName}.nexTemp
