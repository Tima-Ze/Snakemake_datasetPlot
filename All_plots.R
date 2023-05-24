library(dplyr)
library(data.table)
library(dplyr)
library(ggplot2)
library(ggfortify)
set.seed(1)

source('./scripts/Functions.R')
input_file=snakemake@input[["data"]]
input_raw=snakemake@input[["raw"]]
Norm_method=snakemake@params[["norm"]]
output1=file_in(snakemake@output[["boxplot"]])
output2=file_in(snakemake@output[["LibSize"]])
output3=snakemake@output[["PCA"]]

PCA_color=snakemake@params[["PCA_color"]]

########################
#Box & Bar plots
#######################


df= read.table(file.in(input_file), header = T,check.names = F)
if(!dir.exists(file.path( dirname(output1)))) {
    dir.create(file.path(dirname(output1)),recursive = TRUE)}
BOXplot(df)
if(!dir.exists(file.path( dirname(output2)))) {
  dir.create(file.path(dirname(output2)),recursive = TRUE)}
BARplot(df)

########################
#Box & Bar plots raw counts
#######################
print("Box and LibSize ploting for raw counts")
df_raw= read.table(file.in(input_raw), header = T,check.names = F) %>% 
  tibble::column_to_rownames('Genes') %>% select(-c(1:5))

check_and_create_dir("plots/raw", "boxplots")
jpeg(file=paste0('plots/raw/boxplots/', sub("\\.txt","",basename(input_raw)), ".jpeg"),
     quality = 100, width = 1500, height = 1000)
  boxplot(df_raw, las=2, col="gold")
  title(paste("Distribution of log2 count for", sub("\\.txt",'',basename(input_raw))))
  dev.off()
  
check_and_create_dir("plots/raw", "LibSize")
jpeg(file=paste0('plots/raw/LibSize/', sub("\\.txt","",basename(input_raw)), ".jpeg"),
     quality = 100, width = 1500, height = 1000)
par(mar=c(15,7,5,8))
barplot(colSums(df_raw), names=colnames(df_raw),  horiz=TRUE,las=2, xlab="library size", col="lightpink",
        col.axis="Darkblue", 
        cex.names =1 )
title(sub("\\.txt",'',basename(input_raw)))
dev.off()



########################
#PCA
########################

for (i in snakemake@input[['meta']]) {
  assign(paste0(sub("\\.csv","",basename(i)), "_meta"), read.csv(file_in(i)))
  rm(i)}
if(!dir.exists(file.path( dirname(output1)))) {
  dir.create(file.path(dirname(output3)),recursive = TRUE)}

plotPCA(df)



