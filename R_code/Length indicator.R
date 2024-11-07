
library(ggplot2)
library(data.table)
library(patchwork)
library(dplyr)
library(tidyr)

#sets working DIR
setwd("")
datapath <- ""
###Violin plots

##violin plots of the Poly(A) in the whole sample
#reads files and creates a dataframe
Wholereads1<- fread(paste0(datapath, "/11_HD3-ID4-2/read_length.txt"), col.names = c('readlength'))


#sets read ID-Column to Name of data set
Wholereads1$sample<-"Cases-HD3-ID4-ID2"


#combine files to one 
whole_length <- rbind(Wholereads1)

#creates violin plots
whole_v <- ggplot(whole_length, 
                  aes(x=sample, y=readlength)) + 
                  geom_violin(scale = "width")  + 
                  geom_boxplot(width=0.03,  outlier.shape = NA) + 
                  labs(x = NULL)+
                  #ggtitle ("Length of reads in HD3-ID4 Nanopore run") + 
                  theme_classic()

limited_v <- ggplot(whole_length, 
                    aes(x=sample, y=readlength)) + 
                    geom_violin(scale = "width")  + 
                    geom_boxplot(width=0.03,  outlier.shape = NA) + 
                    ylim(0, 300) +
                    labs(x = NULL)+
                    #ggtitle ("Length of reads in HD3-ID4 Nanopore run") + 
                    theme_classic()

limited200_v <- ggplot(whole_length, 
                    aes(x=sample, y=readlength)) + 
                    geom_violin(scale = "width")  + 
                    geom_boxplot(width=0.03,  outlier.shape = NA) + 
                    ylim(0, 250) +
                    labs(x = NULL)+
                    #ggtitle ("Length of reads in HD3-ID4 Nanopore run") + 
                    theme_classic() 

#creating a graph using patchwork
(limited_v | whole_v)/ (limited200_v) + 
    plot_annotation(
      title = "Length of reads in HD3-ID4-2 Nanopore run", 
      theme = theme(plot.title = element_text(hjust = 0.5, size = 15))
                     )

#creates a pdf
pdf(file="Length of reads.pdf", width =12, height = 8) 
(limited_v | whole_v)/ (limited200_v) + 
  plot_annotation(
    title = "Length of reads in HD3-ID4-2 Nanopore run", 
    theme = theme(plot.title = element_text(hjust = 0.5, size = 15))
  )
dev.off()