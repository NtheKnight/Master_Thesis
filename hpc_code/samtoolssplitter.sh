#!/bin/bash
#SBATCH --job-name=STsplitter  # Job name
#SBATCH --mail-type=END,FAIL # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=-- # Where to send mail
#SBATCH --ntasks=1 # Run on a single node
#SBATCH --mem=8gb # Job memory request
#SBATCH --time=12:00:00 # Time limit hrs:min:sec
#SBATCH --output=--/CASES/01_scripts/logs/splitter_%j.log  # Standard output and error log
#SBATCH -p leinecpu


#############################Input###################################
DIR=/hpc--/CASES/02_data/
FOLDER=08_Cases-Treg-HD2
NAME=20240612_1358_MN32174_FAX88319_e12cfcb1
#####################################################################

while read i;

do
time=$(date +"%D %T")
echo "$i @ $time"

module load SAMtools

##DRS
samtools view -f16 -b -o $DIR/"$FOLDER"/"$NAME".hac.trimAdaptor.dorado-0.6.0.HG38align.sorted.CTLA-4.bam $DIR/"$FOLDER"/"$NAME".hac.trimAdaptor.dorado-0.6.0.HG38align.sorted.bam chr2:203857771-203883965
samtools index $DIR/"$FOLDER"/"$NAME".hac.trimAdaptor.dorado-0.6.0.HG38align.sorted.CTLA-4.bam
samtools view -f16 -b -o $DIR/"$FOLDER"/"$NAME".hac.trimAdaptor.dorado-0.6.0.HG38align.sorted.SGMS1.bam $DIR/"$FOLDER"/"$NAME".hac.trimAdaptor.dorado-0.6.0.HG38align.sorted.bam chr10:50304000-50635000
samtools index $DIR/"$FOLDER"/"$NAME".hac.trimAdaptor.dorado-0.6.0.HG38align.sorted.SGMS1.bam
samtools view -f16 -b -o $DIR/"$FOLDER"/"$NAME".hac.trimAdaptor.dorado-0.6.0.HG38align.sorted.RTKN2.bam $DIR/"$FOLDER"/"$NAME".hac.trimAdaptor.dorado-0.6.0.HG38align.sorted.bam chr10:62187000-62270000
samtools index $DIR/"$FOLDER"/"$NAME".hac.trimAdaptor.dorado-0.6.0.HG38align.sorted.RTKN2.bam
samtools view -f16 -b -o $DIR/"$FOLDER"/"$NAME".hac.trimAdaptor.dorado-0.6.0.HG38align.sorted.FXYD1.bam $DIR/"$FOLDER"/"$NAME".hac.trimAdaptor.dorado-0.6.0.HG38align.sorted.bam chr19:35130000-35153000
samtools index $DIR/"$FOLDER"/"$NAME".hac.trimAdaptor.dorado-0.6.0.HG38align.sorted.FXYD1.bam


##NGS
# samtools view -b -o $DIR/"$FOLDER"/"$NAME".hg38.star.Aligned.out.sorted.CTLA-4.bam $DIR/"$FOLDER"/"$NAME".hg38.star.Aligned.out.sorted.bam chr2:203857771-203883965
# samtools index $DIR/"$FOLDER"/"$NAME".hg38.star.Aligned.out.sorted.CTLA-4.bam
# samtools view -b -o $DIR/"$FOLDER"/"$NAME".hg38.star.Aligned.out.sorted.SGMS1.bam $DIR/"$FOLDER"/"$NAME".hg38.star.Aligned.out.sorted.bam chr10:50304000-50635000
# samtools index $DIR/"$FOLDER"/"$NAME".hg38.star.Aligned.out.sorted.SGMS1.bam
# samtools view -b -o $DIR/"$FOLDER"/"$NAME".hg38.star.Aligned.out.sorted.RTKN2.bam $DIR/"$FOLDER"/"$NAME".hg38.star.Aligned.out.sorted.bam chr10:62187000-62270000
# samtools index $DIR/"$FOLDER"/"$NAME".hg38.star.Aligned.out.sorted.RTKN2.bam
# samtools view -b -o $DIR/"$FOLDER"/"$NAME".hg38.star.Aligned.out.sorted.FXYD1.bam $DIR/"$FOLDER"/"$NAME".hg38.star.Aligned.out.sorted.bam chr19:35130000-35153000
# samtools index $DIR/"$FOLDER"/"$NAME".hg38.star.Aligned.out.sorted.FXYD1.bam

#shows ending header to in log to indicate when it finished
    time=$(date +"%D %T")
    echo -e "\n"
    echo -e "		============================================"
    echo -e "		=     finished $i @ $time      ="
    echo -e "		============================================"

done < $DIR/joblist.txt #runs through the given names in the list

#shows ending header to in log to indicate when it finished
    time=$(date +"%D %T")
    echo -e "\n"
    echo -e "		============================================"
    echo -e "		=     finished all at $time    ="
    echo -e "		============================================"