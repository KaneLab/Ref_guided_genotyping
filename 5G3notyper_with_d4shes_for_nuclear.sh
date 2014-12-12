#This program turns a vcf table into a fasta file given a reference sequence
#Inputs are
#$1: multi fasta containing all references unwrapped

#get array of reference genes and length of array
refs=(`grep ">" $1 | tr -d ">"`)
refLen=${#refs[@]}

#get array of vcf files to work on
vcfs=(`ls *.vcf.filtered`)
vcfLen=${#vcfs[@]}

#reference loop
for(( r=0; r<$refLen; r++ )); do

        #store current gene in working name
        cRef=${refs[$r]}

        #make a new multi fasta file to write to
        > ${cRef}.fa

        #get reference in the form to genotype (supports single fasta reference for now)
        grep -A1 $cRef $1 | tail -n1 > tempRef.fa

#loop over vcfs
        for((v=0; v<$vcfLen; v++)); do

                #make temp copy of reference so you don't overwrite reference
                type=`cat tempRef.fa`

                #get the vcf of corrent ecotype
                cVcf=${vcfs[$v]}

                #only take rows that include that referece header from the fasta input
                grep $cRef $cVcf > preSnp
                grep $cRef MASTERDASHFILE > preDashVcf

                cat preSnp preDashVcf > dashVcf

                echo "Working on $cVcf"
                #cat $cVcf MASTERDASHFILE.vcf > preDashVcf
                #grep -v "#" preDashVcf > dashVcf

                #format vcf
                #get positions of snps and snps into array and get lengths
                posArray=(`awk '{print $2}' dashVcf`)
                posLength=${#posArray[@]}

                snpArray=(`awk '{print $5}' dashVcf | awk -F "," '{print $1}'`) #get snp column in vcf. If multiple possible snps(separated by commas), take the first.
                snpLength=${#snpArray[@]}
                #Check to make sure number of SNPs equals number of snp positions
                if [ $posLength -ne $snpLength ]; then
                        echo "Error, the position and snp arrays are not the same length"
                        echo "$2 failed"
                        break
                fi
                #iteratively sub reference nucleotide for current snp at the current position
                for((i=0;i<$posLength;i++));do
                        currentPos=${posArray[$i]}
                        currentSNP=${snpArray[$i]}
                        type=`echo $type | sed "s/./$currentSNP/$currentPos"`
                        #end loop on SNP positions
                done

                #Create new file for the genotyped individual, use $3 command line arg (prefix) for header and file name
                vcfName=`echo $cVcf | awk -F "\." '{print $1}'`
                echo ">$vcfName" >> ${cRef}.fa
                echo $type >> ${cRef}.fa

                rm dashVcf
                rm tempRef.fa
                rm preDashVcf
                #sed -i 's/\,[ATGC]//g' ${3}.fa #Legacy code. This removes nucleotides that appear after commas (and commas), but it's a bad way to do business. See line 16 for improvement.

        done
done
