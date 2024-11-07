#!/bin/bash
#SBATCH --job-name=merger  # Job name
#SBATCH --mail-type=END,FAIL # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=-- # Where to send mail
#SBATCH --ntasks=1 # Run on a single CPU
#SBATCH --mem=32gb # Job memory request
#SBATCH --time=24:00:00 # Time limit hrs:min:sec
#SBATCH --output=--/CASES/01_scripts/logs/merger_%j.log # Standard output and error log
#SBATCH -p leinecpu


#############################Input###################################
OUT=/hpc--/CASES/02_data
#####################################################################

#separate module loading to avoid conflicts
module load SAMtools
# samtools merge -f -o /hpc--/CASES/02_data/14_merged_HD3-HD2-RNA002nonEnr/merged_HD3-HD2-RNA002nonEnr.sorted.FOXP3.bam \
#                     /hpc--/CASES/02_data/01_Cases-HD3-ID-3/01_alignment/Cases-HD3-Treg-3.hac.trimAdaptor.dorado-0.6.0.HG38align.sorted.FOXP3.bam \
#                     /hpc--/CASES/02_data/03_20211208_HD42_Lib1_dRNA002/01_alignment/20211208_HD42_Lib1_dRNA002.hac.trimAdaptor.dorado-0.6.0.HG38align.sorted.FOXP3.bam \
#                     /hpc--/CASES/02_data/04_20211209_HD42_Lib1_RNA002/01_alignment/20211209_HD42_Lib1_RNA002.hac.trimAdaptor.dorado-0.6.0.HG38align.sorted.FOXP3.bam \
#                     /hpc--/CASES/02_data/05_20220105_HD43_dRNA_RNA002/01_alignment/20220105_HD43_dRNA_RNA002.hac.trimAdaptor.dorado-0.6.0.HG38align.sorted.FOXP3.bam \
#                     /hpc--/CASES/02_data/08_Cases-Treg-HD2/01_alignment/20240612_1358_MN32174_FAX88319_e12cfcb1.hac.trimAdaptor.dorado-0.6.0.HG38align.sorted.FOXP3.bam

samtools merge -f -o /hpc--/CASES/02_data/14_merged_HD3-HD2-RNA002nonEnr/merged_HD3-HD2-RNA002nonEnr.polyA.FOXP3.bam \
                    /hpc--/CASES/02_data/01_Cases-HD3-ID-3/Cases-HD3-Treg-3.hac.trimAdaptor.dorado-0.6.0.polyA.FOXP3.bam \
                    /hpc--/CASES/02_data/03_20211208_HD42_Lib1_dRNA002/20211208_HD42_Lib1_dRNA002.hac.trimAdaptor.dorado-0.6.0.polyA.FOXP3.bam \
                    /hpc--/CASES/02_data/04_20211209_HD42_Lib1_RNA002/20211209_HD42_Lib1_RNA002.hac.trimAdaptor.dorado-0.6.0.polyA.FOXP3.bam \
                    /hpc--/CASES/02_data/05_20220105_HD43_dRNA_RNA002/20220105_HD43_dRNA_RNA002.hac.trimAdaptor.dorado-0.6.0.polyA.FOXP3.bam \
                    /hpc--/CASES/02_data/08_Cases-Treg-HD2/20240612_1358_MN32174_FAX88319_e12cfcb1.hac.trimAdaptor.dorado-0.6.0.polyA.FOXP3.bam

#     time=$(date +"%D %T")
#     echo -e "\n"
#     echo -e "		============================================"
#     echo -e "		=     merge finished at $time    ="
#     echo -e "		============================================"
# samtools calmd -b /hpc--/CASES/02_data/upstream_all_merge.bam \
#                   --/data/reference_genomes/Hybrid_genomes/HG38filt.fasta > /hpc--/CASES/02_data/upstream_all_merge.fixed.bam 




#shows ending header to in log to indicate when it finished
    time=$(date +"%D %T")
    echo -e "\n"
    echo -e "		============================================"
    echo -e "		=     finished all at $time    ="
    echo -e "		============================================"