;alsdkjf;aljf#format fasta file for downstream processes
#$1 in fasta file to correct

#get beginning of file name
file=`echo $1`

#edit genbank name formatting, which gums up the rest of the workflow
#get rid of all white spaces, except carriage returns between headers and sequences
awk '$1 ~ /^>/ {print $0 "QQQQ"} $1 !~ /^>/ {print $0}' $1  | tr -d "\n\t ^M" | sed 's/>/\n>/g'  | sed 's/QQQQ/\n/g' | sed '/^$/d' > ${1}_unwrapped.fa

echo "There is now a file called ${1}_unwrapped.fa in your directory."
