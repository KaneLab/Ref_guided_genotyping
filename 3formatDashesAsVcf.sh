#format a .DASH file into pseudo-vcf format for downstream G3notyper_with_d4shes.sh usage
for i in `ls *.DASH`; do
        cat ${i} | sort -u | sort -k2,2n | awk '{print $1"      "$2"    .       .       -"}' >> ${i}FILE
done

cat *.DASHFILE > MASTERDASHFILE
