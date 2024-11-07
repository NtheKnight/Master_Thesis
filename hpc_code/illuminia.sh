#!/bin/bash
#SBATCH --job-name=trimmer  # Job name
#SBATCH --mail-type=END,FAIL # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=-- # Where to send mail
#SBATCH --ntasks=1 # Run on a single node
#SBATCH --mem=32gb # Job memory request
#SBATCH --time=18:00:00 # Time limit hrs:min:sec
#SBATCH --output=--/CASES/01_scripts/logs/illumina_processor%j.log  # Standard output and error log
#SBATCH -p leinecpu


####################################################################################TODO, not finished, has to be adjusted for mouse genome and data#########################
#############################Input###################################
DIR=--/CASES/02_results/00_test.treg-data/
#####################################################################

echo "start"

while read i;

do
echo $i
time=$(date +"%D %T")
echo "@ $time"
## trimming of the data; ToDO check if it works
module load Trim_Galore
    trim_galore --paired --length 30 --q 30 --gzip -o $DIR/"$i"_R1.fastq $DIR/"$i"_R2.fastq
module unload Trim_Galore

## shows ending header to in log to indicate when it finished
    time=$(date +"%D %T")
    echo -e "\n"
    echo -e "		============================================"
    echo -e "		< trimming of $i ended @ $time  >"
    echo -e "		============================================"

### BOWTIE2 ALIGNMENT
module load Bowtie2/2.4.4-GCC-10.2.0
module load SAMtools/1.15.1-GCC-10.2.0
module load BBMap/38.96-GCC-10.2.0
module load Sambamba/0.8.0-GCC-10.2.0
module load BEDTools/2.27.1-GCC-10.2.0


## Idexing of refernce file
bowtie2-build --/users/Niclas/data/00_referenz_Genome/02_EMC1/reoEMC1.fasta --/users/Niclas/data/00_referenz_Genome/02_EMC1/01_indexed/01_reoEMC1/reoEMC1

## shows  when it finished
    time=$(date +"%D %T")
    echo -e "\n"
    echo -e "		\e[1;33;44m############################################\e[0m"
    echo -e "		\e[1;33;44m#  Indexing Mouse $time        #\e[0m"
    echo -e "		\e[1;33;44m############################################\e[0m"


## adjusted for fasta input through -f, if fastq is used replace by -q
bowtie2 -p 4 -X 1000 -f -k 2 --local -x $DIR/00_referenz_Genome/01_dumas/01_indexed/01_reoDumas/reoDumas $DIR/00_referenz_Genome/04_positive_control_softClips/positive_control_softClips.fasta -S $DIR/positive_Control_SoftClipping/aligned-local_reoDumas_Control.sam

samtools view -bS -o $DIR/positive_Control_SoftClipping/aligned-local_reoDumas_Control.bam $DIR/positive_Control_SoftClipping/aligned-local_reoDumas_Control.sam
samtools sort -o $DIR/positive_Control_SoftClipping/aligned-local_reoDumas_Control.sorted.bam $DIR/positive_Control_SoftClipping/aligned-local_reoDumas_Control.bam
samtools index $DIR/positive_Control_SoftClipping/aligned-local_reoDumas_Control.sorted.bam

## shows  when it finished
    time=$(date +"%D %T")
    echo -e "\n"
    echo -e "		============================================"
    echo -e "		< Alignment of $i ended @ $time  >"
    echo -e "		============================================"

### Extract Dumas alignments
#Extract only alignments against Dumas (VZV Genome)
samtools view -bS -o $DIR/positive_Control_SoftClipping/aligned-local_reoDumas_Control.sorted.clean.bam $DIR/positive_Control_SoftClipping/aligned-local_reoDumas_Control.sorted.bam reoDumas.fasta:1
samtools index $DIR/positive_Control_SoftClipping/aligned-local_reoDumas_Control.sorted.clean.bam

## Extraciting alignments in the FOXP3 region
# samtools view -bS -o $OUT/"$i".hg38.star.Aligned.out.bam $OUT/"$i".hg38.star.Aligned.out.sam
# samtools sort -o $OUT/"$i".hg38.star.Aligned.out.sorted.bam $OUT/"$i".hg38.star.Aligned.out.bam
# samtools index $OUT/"$i".hg38.star.Aligned.out.sorted.bam

# ##filtering for only the FOXP3 region
# samtools view -b -o $IN/02_results/"$i".hg38.star.Aligned.out.sorted.FOXP3.bam $IN/01_alignment/"$i".hg38.star.Aligned.out.sorted.bam chrX:49250438-49300000
# samtools index $IN/02_results/"$i".hg38.star.Aligned.out.sorted.FOXP3.bam



### Removal of unnecessary data

# rm $DIR/positive_Control_SoftClipping/aligned-local_reoDumas_Control.sam
# rm $DIR/positive_Control_SoftClipping/aligned-local_reoDumas_Control.bam
# rm $DIR/positive_Control_SoftClipping/aligned-local_reoDumas_Control.sorted.bam
# rm $DIR/positive_Control_SoftClipping/aligned-local_reoDumas_Control.sorted.bam.bai

## shows  when it finished
 time=$(date +"%D %T")
    echo -e "\n"
    echo -e "		============================================"
    echo -e "		< Extraction of $i ended @ $time  >"
    echo -e "		============================================"






done < $DIR/joblist.txt #runs through the given names in the list

#shows ending header to in log to indicate when it finished
    time=$(date +"%D %T")
    echo -e "\n"
    echo -e "		============================================"
    echo -e "		=     finished all at $time    ="
    echo -e "		============================================"