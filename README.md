Ref_guided_genotyping
=====================
Required:
.sorted.bam for each individual to genotype
.depth files (Use "samtools depth [indiv].sorted.bam > [indiv].depth")
A list of depth files called 'ecotypeDepthList'.
A reference fasta (or multifasta)
.vcf tables

Step 0:  Call 0fasta_unwrap.sh <name of fasta reference>.  Unwraps the fasta file to put the sequence on one line.

Step 1:  Call 1globalMedianGetter.sh .  This file must be in the folder containing each individual's .depth file.  It generates a list of global median depth of coverage for those individuals (2nd column) with the individual's name (1st column).  Output is called "globalMedians".

Step 2:  Call 2geneByEcoTypeDashVCFMake.sh <geneNameList>.  This needs to be in the folder containing ecotypeDepthList, globalMedians, and the reference multifasta, as well as a list of gene names.  It creates a directory called allGeneDASHFILES and generates a file containing the positions of where dashes need to go for each gene, and places it in this directory.

Step 3:  Call 3formatDashesAsVcf.sh .  Reformats the .DASH files into pseudo-vcf format, for later use in the G3notyper_with_d4shes.sh script.  Output is in .DASHFILE format.

Step 4:  Call 4filterVCF.sh <int>.  Filters all vcfs in folder to a specified quality threshold.  Output format is .vcf.filtered

Step 5:  Call 5dashInserter.sh <reference>.  Calls the G3notyper_with_d4shes.sh function on multiple .vcf.filtered files and outputs a multi-fasta formatted file with each individual's genotype.
