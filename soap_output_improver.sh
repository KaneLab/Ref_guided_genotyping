#format fasta file for downstream processes
#$1 in fasta file to correct

#get beginning of file name
sed 's/  /_cov_/g' $1 | sed 's/ /_cov_/g' | awk '$1 ~ /^>/ {print $0 "QQQQ"} $1 !~ /^>/ {print $0}' | tr -d "\n\t ^M" | sed 's/>/\n>/g' > tmp

cat tmp | awk '{ print length, $0 }' | sort -nr -s | cut -d " " -f2- | sed 's/QQQQ/\n/g' | sed '/^$/g' > Improved${1}
#rm tmp

echo "There is now a file called Improved${1} in your directory."
