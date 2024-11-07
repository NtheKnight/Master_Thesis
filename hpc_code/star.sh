#!/bin/bash
#SBATCH --job-name=Star-Align  # Job name
#SBATCH --mail-type=END,FAIL # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=-- # Where to send mail
#SBATCH --ntasks=1 # Run on a single CPU
#SBATCH --mem=64gb # Job memory request
#SBATCH --time=36:00:00 # Time limit hrs:min:sec
#SBATCH --output=--/CASES/01_scripts/logs/Star_%j.log  # Standard output and error log
#SBATCH -p leinecpu

#############################Input###################################
IN=/hpc--/CASES/02_data/09_HD3-ID-5_Illumina
OUT=/hpc--/CASES/02_data/09_HD3-ID-5_Illumina/01_alignment
WORK=/hpc--/CASES/02_data/09_HD3-ID-5_Illumina
#####################################################################


while read i;

do

echo $i

#Changes to working directory
cd $IN/


# #trimms data
# #without quality filtering
# module load Trim_Galore
# trim_galore --q 30 --paired --length 30  $IN/"$i"_R1_001.fastq.gz $IN/"$i"_R2_001.fastq.gz
# module unload Trim_Galore


### STAR ALIGNMENT
#STAR is very sensitive dependencies can interfere, purge modules before running
# module purge
# module load STAR/2.7.9a-GCC-10.2.0

# STAR --genomeDir /hpc--/data/STARindexes/HG38 --runThreadN 4 --readFilesIn $IN/"$i"_R1_001_val_1.fq $IN/"$i"_R2_001_val_2.fq --outFileNamePrefix $OUT/"$i".hg38.star. --genomeLoad NoSharedMemory

# #shows ending header to in log to indicate when it finished
#     time=$(date +"%D %T")
#     echo -e "\n"
#     echo -e "		============================================"
#     echo -e "		<  alignment of $i done @ $time  >"
#     echo -e "		============================================"

module load SAMtools/1.15.1-GCC-10.2.0 
module load BEDTools/2.27.1-GCC-10.2.0

## against Human
samtools view -bS -o $OUT/"$i".hg38.star.Aligned.out.bam $OUT/"$i".hg38.star.Aligned.out.sam
samtools sort -o $OUT/"$i".hg38.star.Aligned.out.sorted.bam $OUT/"$i".hg38.star.Aligned.out.bam
samtools index $OUT/"$i".hg38.star.Aligned.out.sorted.bam

##filtering for only the FOXP3 region
samtools view -b -o $WORK/02_results/"$i".hg38.star.Aligned.out.sorted.FOXP3.bam $OUT/"$i".hg38.star.Aligned.out.sorted.bam chrX:49250438-49300000
samtools index $WORK/02_results/"$i".hg38.star.Aligned.out.sorted.FOXP3.bam

##filtering for the LIRIL2R Region
samtools view -b -o $WORK/02_results/"$i".hg38.star.Aligned.out.sorted.LIRIL2R.bam $OUT/"$i".hg38.star.Aligned.out.sorted.bam chr6:179168-206466
samtools index $WORK/02_results/"$i".hg38.star.Aligned.out.sorted.LIRIL2R.bam



done < $WORK/joblist.txt
