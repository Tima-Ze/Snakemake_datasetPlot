library(edgeR)
library(DESeq2)
library(data.table)
library(dplyr)
library(rtracklayer)


#############input,output,directories################
input_file <- snakemake@input[['featurecount']]
output_file=snakemake@output[[]]
gtf=snakemake@input[['gtf']]
norm=snakemake@params[["norm"]]
output_dir <- dirname(file_in(output_file))

if(!dir.exists(file.path(output_dir))) {
  dir.create(file.path(output_dir),recursive = TRUE)}
################read files#############################
df=fread(file.in(input_file), header = T,check.names = F)


###################Pick PC and lnc##################
#Prepare A LIST OF PROTEIN CODING and LncRNA Gene IDs:
genelist <- rtracklayer::import() %>% 
  data.frame() %>% select("gene_id", "gene_biotype") %>% 
  filter(gene_biotype%in%c("protein_coding", "lncRNA")) %>% 
  unique()


###################Functions#######################
DESeqNorm=function(a,b){
  dds <- DESeqDataSetFromMatrix(round(a), colData = b, design = ~condition)
  dds$condition <- relevel(dds$condition, ref = 'control')
  dds <- estimateSizeFactors(dds)
  normDseq <- counts(dds, normalized = T)%>% as.data.frame()
  return(normDseq)
}
TMMnorm=function(d){
  y <- DGEList(counts=d)
  y <- calcNormFactors(y,method = "TMM")
  cpmTMM <- cpm(y, log=F) %>% as.data.frame()
  return(cpmTMM)
}
tpm <- function(counts, lengths) {
  rate <- counts / lengths
  rate / sum(rate) * 1e6
}
TPMnorm=function(cnt){
  tmp=cnt %>%
    tidyr::gather(sample, cnt, 7:ncol(cnt)) %>%
    group_by(sample) %>%
    mutate(tpm=tpm(cnt, Length)) %>%
    select(-cnt) %>%
    tidyr::spread(sample, tpm) %>% 
    dplyr::select(-c(2:6)) %>% 
    tibble::column_to_rownames("Genes")
  return(tmp)
}
#####################################
#run normalization and kick out low expressed genes
####################################

if(norm=="Deseq2_norm"){
    for (i in snakemake@input[['meta']]) {
      assign(paste0(sub("\\.csv","",basename(i)), "_meta"), read.csv(i))
      rm(i)}
    meta=ls(pattern = "*_meta") %>% purrr::reduce(rbind) %>% 
      select('fileName', 'condition') %>% 
      arrange(condition)
    df <- df %>%
    filter(Genes%in%genelist$gene_id) %>% 
    tibble::column_to_rownames("Genes") %>% 
    select(-c(1:5)) %>% 
    select(meta$fileName)
  #filter genes based on cpm to avoid favoring genes that are expressed in larger libraries 
  df <- df[rowSums(cpm(df)>=1) >= ncol(df)*0.7 ,] 
  norm <- DESeqNorm(df, meta)
  fwrite(norm, file_in(output_file), sep = '\t', quote=F,row.names=T,col.names=T)
}if(norm=="TMM_norm"){
  df <- df %>%
    filter(Genes%in%genelist$gene_id) %>% 
    tibble::column_to_rownames("Genes") %>% 
    select(-c(1:5))
  
  cpmTMM <- TMMnorm(df)
  cpmTMM <- cpmTMM[rowSums(cpmTMM>=1)>= round(ncol(cpmTMM))*0.7,]
  fwrite(cpmTMM, file_in(output_file), sep = '\t', quote=F,row.names=T,col.names=T)
}if(norm=="TPM_norm"){
  df <- df %>%
    filter(Genes%in%genelist$gene_id)
  
  tmp <- TPMnorm(df)
  tmp <- tmp[rowSums(tmp>=1)>= round(ncol(tmp))*0.7,]
  fwrite(tpm, file_in(output_file), sep = '\t', quote=F,row.names=T,col.names=T)
}
