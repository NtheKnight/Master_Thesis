#!/bin/bash
#SBATCH --job-name=trimmer  # Job name
#SBATCH --mail-type=END,FAIL # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=-- # Where to send mail
#SBATCH --ntasks=1 # Run on a single node
#SBATCH --mem=32gb # Job memory request
#SBATCH --time=18:00:00 # Time limit hrs:min:sec
#SBATCH --output=--/CASES/01_scripts/logs/trimming_%j.log  # Standard output and error log
#SBATCH -p leinecpu


#############################Input###################################
DIR=--/CASES/02_data/00_treg-data
#####################################################################

while read i;

do
time=$(date +"%D %T")
echo "$i @ $time"

module load Trim_Galore

trim_galore --paired --length 30 --q 30 $DIR/"$i"_1.fastq $DIR/"$i"_2.fastq

module unload Trim_Galore

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