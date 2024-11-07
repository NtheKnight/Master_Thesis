#!/bin/bash
#SBATCH --job-name=CASES_Dorado_Basecall  # Job name
#SBATCH --mail-type=END,FAIL # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=-- # Where to send mail
#SBATCH --ntasks=1
#SBATCH --mem=32gb # Job memory request
#SBATCH --time=18:00:00 # Time limit hrs:min:sec
#SBATCH --output=--/CASES/01_scripts/logs/dorado_0.7.3_%j.log # Standard output and error log
#SBATCH -p leinegpu_long
#SBATCH --gres=gpu:a100-sxm4-40gb:1

#altGPU --gres=gpu:1
#altGPU --nodelist=leinevmgpu002

while read i;

do
time=$(date +"%D %T")
echo "$IN @ $time"

#############################Input###################################
IN=/hpc--/data/Nanopore-Pod5/Cases-Treg-7/20240911_1327_MN32174_FAZ54913_6b9afda9/
DORADO=/hpc--/dorado-0.7.3-linux-x64/bin/dorado
MODELPATH=--/dorado-models
MODEL=rna004_130bps_hac@v5.0.0
TRIMTYPE=hac.trimAdaptor
OUT=/hpc--/CASES/02_data/12_Cases-Treg-7/
#####################################################################

#extracts approximate name from the input path/file
NAME=$(echo "$IN" | awk -F/ '{print $8}' | sed -r -n 's/(.*)/\1/p')
echo $NAME

#extracts the version number from the dorado script
VERSION=$(echo "$DORADO" | awk -F/ '{print $5}' | cut -c 1-12)
echo $VERSION

#sets (and creates)Working Directory
    #mkdir $OUT/"$NAME"
    cd $OUT

## basecalling
$DORADO basecaller --trim adapters --recursive "$MODELPATH"/"$MODEL" $IN > $OUT/"$NAME"."$TRIMTYPE"."$VERSION".bam

## generate summary file
$DORADO summary $OUT/"$NAME"."$TRIMTYPE"."$VERSION".bam > $OUT/"$NAME"."$TRIMTYPE"."$VERSION".sequencing_summary.txt

## basecalling with poly A Tag
$DORADO basecaller --estimate-poly-a  --recursive "$MODELPATH"/"$MODEL" $IN/ > $OUT/"$NAME"."$TRIMTYPE"."$VERSION".polyA.bam




# convert bam to fastq
module load BEDTools
bamToFastq -i $OUT/"$NAME"."$TRIMTYPE"."$VERSION".bam -fq $OUT/"$NAME"."$TRIMTYPE"."$VERSION".fastq

#shows ending header to in log to indicate when it finished
    time=$(date +"%D %T")
    echo -e "\n"
    echo -e "		============================================"
    echo -e "		=     finished $i @ $time      ="
    echo -e "		============================================"

done < --/CASES/01_scripts/joblist.txt #runs through the given names in the list


#shows ending header to in log to indicate when it finished
    time=$(date +"%D %T")
    echo -e "\n"
    echo -e "		============================================"
    echo -e "		=     finished all at $time    ="
    echo -e "		============================================"