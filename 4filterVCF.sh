#simple script, filters vcf to have only snp row with specified quality (positional argument)
#$1 is quality score cutoff


#check if vfc file exist in directory
if [ `ls *.vcf | wc -l | cut -f1` -eq 0 ]
then
        echo "There are no files ending in .vcf in your current directory."
else
        #loop through each vcf, remove comments (#), only keep snps ($8) above quality threshold ($6)
        for i in `ls *.vcf`
        do
                awk -v qual=$1 '$6 >= qual && $1 !~ /^#/ && $8 ~ /^DP/' $i > ${i}.filtered
        done
fi
