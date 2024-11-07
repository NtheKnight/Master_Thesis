#!/bin/bash
#SBATCH --job-name=bedgrapher  # Job name
#SBATCH --mail-type=END,FAIL # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user= # Where to send mail
#SBATCH --ntasks=1 # Run on a single CPU
#SBATCH --mem=64gb # Job memory request
#SBATCH --time=36:00:00 # Time limit hrs:min:sec
#SBATCH --output=--/CASES/01_scripts/logs/bedgrapher_%j.log # Standard output and error log
#SBATCH -p leinecpu

#####################################################################
BASE=--/CASES/02_data/09_HD3-ID-5_Illumina/01_alignment/
WORK=--/CASES/02_data/09_HD3-ID-5_Illumina/02_results/
TRIMM=--/CASES/02_data/09_HD3-ID-5_Illumina/
#####################################################################

module load SAMtools
module load BEDTools

while read i;

do
echo $i

###### SECTION FOR Extraction of reads #####################################################################################
######
## Extracting the  reads and creating the bedgraphs
# samtools view -b -f 83 $BASE/"$i".hg38.star.Aligned.out.sorted.bam > $WORK/"$i".hg38.star.Aligned.out.sorted.fwd1.bam
# samtools view -b -f 163 $BASE/"$i".hg38.star.Aligned.out.sorted.bam > $WORK/"$i".hg38.star.Aligned.out.sorted.fwd2.bam
# samtools index $WORK/"$i".hg38.star.Aligned.out.sorted.fwd1.bam
# samtools index $WORK/"$i".hg38.star.Aligned.out.sorted.fwd2.bam
# samtools merge -f $WORK/"$i".hg38.star.Aligned.out.sorted.fwd.bam $WORK/"$i".hg38.star.Aligned.out.sorted.fwd1.bam $WORK/"$i".hg38.star.Aligned.out.sorted.fwd2.bam
# samtools index $WORK/"$i".hg38.star.Aligned.out.sorted.fwd.bam

# samtools view -b -f 99 $BASE/"$i".hg38.star.Aligned.out.sorted.bam > $WORK/"$i".hg38.star.Aligned.out.sorted.rev1.bam
# samtools view -b -f 147 $BASE/"$i".hg38.star.Aligned.out.sorted.bam > $WORK/"$i".hg38.star.Aligned.out.sorted.rev2.bam
# samtools index $WORK/"$i".hg38.star.Aligned.out.sorted.rev1.bam
# samtools index $WORK/"$i".hg38.star.Aligned.out.sorted.rev2.bam
# samtools merge -f $WORK/"$i".hg38.star.Aligned.out.sorted.rev.bam $WORK/"$i".hg38.star.Aligned.out.sorted.rev1.bam $WORK/"$i".hg38.star.Aligned.out.sorted.rev2.bam
# samtools index $WORK/"$i".hg38.star.Aligned.out.sorted.rev.bam

samtools view -b $WORK/"$i".hg38.star.Aligned.out.sorted.fwd.bam | genomeCoverageBed -ibam stdin -bg -split > $WORK/"$i".hg38.star.Aligned.out.sorted.fwd.bedgraph
samtools view -b $WORK/"$i".hg38.star.Aligned.out.sorted.rev.bam | genomeCoverageBed -ibam stdin -bg -split > $WORK/"$i".hg38.star.Aligned.out.sorted.rev.bedgraph

##############################################################################################################################################

done < $TRIMM/joblist.txt

