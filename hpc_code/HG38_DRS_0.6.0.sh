#!/bin/bash
#SBATCH --job-name=human-minimap2  # Job name
#SBATCH --mail-type=END,FAIL # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=-- # Where to send mail
#SBATCH --ntasks=1 # Run on a single CPU
#SBATCH --mem=64gb # Job memory request
#SBATCH --time=24:00:00 # Time limit hrs:min:sec
#SBATCH --output=--/CASES/01_scripts/logs/human-minimap2-aligner_0.6.0_%j.log # Standard output and error log
#SBATCH -p leinecpu



#runs a while loop from the joblist row by row (-r), while using the first word as $IN and the second as $i (separated by " ")
while read -r IN i ;

do

time=$(date +"%D %T")
echo ""$i" @ $time"

#############################Input###################################
#IN=/hpc--/CASES/02_data/12_Cases-Tconv-7/
DORADO=/hpc--/dorado-0.6.0-linux-x64/bin/dorado
MODELPATH=--/dorado-models
MODEL=rna004_130bps_hac@v5.0.0
TRIMTYPE=hac.trimAdaptor
OUT=$IN/01_alignment/
#####################################################################

#extracts approximate name from the input path/file
# NAMEREV=$(echo "$IN" | rev | cut -d'/' -f2 | rev)
# NAME=${NAMEREV:3}
NAME="$i"
echo $NAME

#extracts the version number from the dorado script
VERSION=$(echo "$DORADO" | awk -F/ '{print $5}' | cut -c 1-12)

module load minimap2/2.24-GCC-10.2.0
module load SAMtools/1.15.1-GCC-10.2.0 
module load BEDTools/2.27.1-GCC-10.2.0
module load HDF5/1.12.1-GCC-10.2.0
module load VBZ-Compression/1.0.1-GCC-10.2.0
module load BBMap
module load Sambamba

# #sets Working Directory and creates output funnel
    mkdir $IN/01_alignment
    mkdir $IN/02_results
    cd $OUT/

# # aligns the reads against the human genome
# minimap2 -ax splice -k14 -uf --secondary=no --/data/reference_genomes/Hybrid_genomes/HG38filt.fasta $IN/"$NAME"."$TRIMTYPE"."$VERSION".fastq > $OUT/"$NAME"."$TRIMTYPE"."$VERSION".HG38align.sam 

# # sam to bam conversion
#     samtools view -b -F2308 -o $OUT/"$NAME"."$TRIMTYPE"."$VERSION".HG38align.bam $OUT/"$NAME"."$TRIMTYPE"."$VERSION".HG38align.sam 
#     samtools sort -o $OUT/"$NAME"."$TRIMTYPE"."$VERSION".HG38align.sorted.bam $OUT/"$NAME"."$TRIMTYPE"."$VERSION".HG38align.bam
#     samtools index $OUT/"$NAME"."$TRIMTYPE"."$VERSION".HG38align.sorted.bam 

# aligns the reads against the human genome with ENO2
minimap2 -ax splice -k14 -uf --secondary=no /hpc--/data/reference_genomes/Hybrid_genomes/HG38filt_incRNACS.fasta $IN/"$NAME"."$TRIMTYPE"."$VERSION".fastq > $OUT/"$NAME"."$TRIMTYPE"."$VERSION".HG38_ENO2_align.sam 

# sam to bam conversion ENO2 aligns
    samtools view -b -F2308 -o $OUT/"$NAME"."$TRIMTYPE"."$VERSION".HG38_ENO2_align.bam $OUT/"$NAME"."$TRIMTYPE"."$VERSION".HG38_ENO2_align.sam
    samtools sort -o $OUT/"$NAME"."$TRIMTYPE"."$VERSION".HG38_ENO2_align.sorted.bam $OUT/"$NAME"."$TRIMTYPE"."$VERSION".HG38_ENO2_align.bam
    samtools index $OUT/"$NAME"."$TRIMTYPE"."$VERSION".HG38_ENO2_align.sorted.bam 

# # aligns the reads against the human coding sequence
# minimap2 -t 8 -ax map-ont -L -p 0.99 --/data/reference_transcriptomes/GRCh38.p13.gencode.v42.transcripts.fasta $IN/"$NAME"."$TRIMTYPE"."$VERSION".fastq > $OUT/"$NAME"."$TRIMTYPE"."$VERSION".GR38CDSalign.sam
# # sam to bam conversion
#     samtools view -b -F2308 -o $OUT/"$NAME"."$TRIMTYPE"."$VERSION".GR38CDSalign.bam $OUT/"$NAME"."$TRIMTYPE"."$VERSION".GR38CDSalign.sam 
#     samtools sort -o $OUT/"$NAME"."$TRIMTYPE"."$VERSION".GR38CDSalign.sorted.bam $OUT/"$NAME"."$TRIMTYPE"."$VERSION".GR38CDSalign.bam
#     samtools index $OUT/"$NAME"."$TRIMTYPE"."$VERSION".GR38CDSalign.sorted.bam 

#counts all reads; once on HG38 align, once on HG38 ENO2 align, displays aligning and non alignign: Flag 0 & 16 align, Flag 4 does not
    samtools view $OUT/"$NAME"."$TRIMTYPE"."$VERSION".HG38align.sam | cut -f 2 | sort | uniq -c > $IN/02_results/readcount.totalHG38.alignment.txt
    samtools view $OUT/"$NAME"."$TRIMTYPE"."$VERSION".HG38_ENO2_align.sam | cut -f 2 | sort | uniq -c > $IN/02_results/readcount.totalHG38_ENO2.alignment.txt

#counts amount of ENO2 reads
    samtools view  $OUT/"$NAME"."$TRIMTYPE"."$VERSION".HG38_ENO2_align.sam | awk '$3 ~ /ENO2/'| cut -f 2 | sort | uniq -c > $IN/02_results/readcount.ENO2.alignment.txt

#extracts read length from dorado into a txt file
    cut -f10 $IN/"$NAME"."$TRIMTYPE"."$VERSION".sequencing_summary.txt > $IN/02_results/readlength.dorado.txt

#extracts read length of all aligning reads
    samtools view $OUT/"$NAME"."$TRIMTYPE"."$VERSION".HG38_ENO2_align.sam | awk '$2 == 0 || $2 == 16' | cut -f10 | awk '{print length}' > $IN/02_results/readlength.all.aligning.txt
#extracts read length of nonENO2 aligned reads
    samtools view $OUT/"$NAME"."$TRIMTYPE"."$VERSION".HG38_ENO2_align.sam | awk '$2 == 0 || $2 == 16' | awk '$3 !~ /ENO2/' | cut -f10 | awk '{print length}' > $IN/02_results/readlength.nonENO2.aligning.txt
#extracts read length of non alignign reads
    samtools view $OUT/"$NAME"."$TRIMTYPE"."$VERSION".HG38_ENO2_align.sam | awk '$2 == 4' | cut -f10 | awk '{print length}' > $IN/02_results/readlength.nonaligning.txt

#identifies all ENO2 reads for filtering
    samtools view $OUT/"$NAME"."$TRIMTYPE"."$VERSION".HG38_ENO2_align.sam | awk '$3 ~ /ENO2/' | cut -f1 > $IN/02_results/ENO2.reads.txt

##filtering of only the FOXP3 region
    samtools view -f16 -b -o $OUT/"$NAME"."$TRIMTYPE"."$VERSION".HG38align.sorted.FOXP3.bam $OUT/"$NAME"."$TRIMTYPE"."$VERSION".HG38align.sorted.bam chrX:49250438-49300000
    samtools index $OUT/"$NAME"."$TRIMTYPE"."$VERSION".HG38align.sorted.FOXP3.bam

#extracts read length of all FOXP3 aligning reads 
samtools view $OUT/"$NAME"."$TRIMTYPE"."$VERSION".HG38align.sorted.FOXP3.bam | cut -f10 | awk '{print length}' > $IN/02_results/readlength.FOXP3.aligning.txt

#extracting IDs, with length of poly-A tail into a .txt
####this part requieres dorado to have run in the -pt mode, to create the PolyA.bam, else this code wont work!###

#extracting the read names from only the FOXP3 reads
    samtools view $OUT/"$NAME"."$TRIMTYPE"."$VERSION".HG38align.sorted.FOXP3.bam | cut -f1 > $IN/02_results/FOXP3-reads."$NAME".txt
#extracting the read names of all reads
    samtools view $OUT/"$NAME"."$TRIMTYPE"."$VERSION".HG38align.sorted.bam | cut -f1 > $IN/02_results/HG38-reads."$NAME".txt 
#filtering the PolyA file just for the FOXP3 reads and creating a new file containg only them 
    filterbyname.sh include=true sam=1.3 overwrite=true in=$IN/"$NAME"."$TRIMTYPE"."$VERSION".polyA.bam out=$IN/"$NAME"."$TRIMTYPE"."$VERSION".polyA.FOXP3.bam names=$IN/02_results/FOXP3-reads."$NAME".txt
#filtering the PolyA file for the whole aligned reads and creating a new file containing them
    filterbyname.sh include=true sam=1.3 overwrite=true in=$IN/"$NAME"."$TRIMTYPE"."$VERSION".polyA.bam out=$IN/"$NAME"."$TRIMTYPE"."$VERSION".polyA.HG38align.bam names=$IN/02_results/HG38-reads."$NAME".txt

#filters the filtered polyA bam for the length of Poly-A-Tails
    samtools view  $IN/"$NAME"."$TRIMTYPE"."$VERSION".polyA.FOXP3.bam | grep pt | awk '{print $1"\t"$NF}' | sed 's/pt:i://g' > $IN/02_results/reads.FOXP3.Poly-A."$NAME".txt
    samtools view  $IN/"$NAME"."$TRIMTYPE"."$VERSION".polyA.HG38align.bam | grep pt | awk '{print $1"\t"$NF}' | sed 's/pt:i://g' > $IN/02_results/reads.Poly-A."$NAME".txt

##extracts number of reads without and with Poly tails from before created lists
#Poly-A-counts in FOXP3
    wc -l $IN/02_results/FOXP3-reads."$NAME".txt > $IN/02_results/counts.FOXP3.Poly-A."$NAME".txt 
    wc -l $IN/02_results/reads.FOXP3.Poly-A."$NAME".txt >> $IN/02_results/counts.FOXP3.Poly-A."$NAME".txt
#Poly-A-Counts in the whole genome
    wc -l $IN/02_results/HG38-reads."$NAME".txt > $IN/02_results/counts.whole.Poly-A."$NAME".txt 
    wc -l $IN/02_results/reads.Poly-A."$NAME".txt >> $IN/02_results/counts.whole.Poly-A."$NAME".txt


#shows ending header to in log to indicate when it finished
    time=$(date +"%D %T")
    echo -e "\n"
    echo -e "		============================================"
    echo -e "		=     finished $i @ $time      ="
    echo -e "		============================================"

done < /hpc--/CASES/02_data/joblist.txt #$IN/joblist.txt #runs through the given names in the list


#shows ending header to in log to indicate when it finished
    time=$(date +"%D %T")
    echo -e "\n"
    echo -e "		============================================"
    echo -e "		=     finished all at $time    ="
    echo -e "		============================================"
