library(dplyr)
require(data.table)

##############################################################input,output,directories######################################

input_file <- snakemake@input[['featurecount']]
output_file=snakemake@output[[]]
name <- snakemake@wildcards[['rawCounts']]
output_dir <- dirname(file_in(output_file))

if(!dir.exists(file.path(output_dir))) {
  dir.create(file.path(output_dir),recursive = TRUE)}

###############################################################read, polish and save###########################################

for (i in snakemake@input[['meta']]) {
  assign(sub("\\.csv","",basename(i)), read.csv(i))
  rm(i)
}

all=ls() %>% purrr::reduce(rbind) %>% 
  select(fileName)



for (i in name){
  tmp=get(i) %>% 
    mutate(Genes=gsub('\\.[0-9]*',"", Geneid), .before=Geneid)%>% 
    dplyr::select(-Geneid) %>%
    setnames(sub('.accepted_hits.sort.coord.combined.Aligned.out.bam', "", names(.)))%>%
    setnames(sub('.r.Aligned.out.bam', "", names(.))) %>%
    setnames(basename(names(.)))
  if (i=="mayo_CER"){
    names(tmp)=stringr::str_extract(names(tmp), "\\d*_CER" )
    assign(i, tmp)
  } else{
    assign(i, tmp)
  }
  rm(i, tmp)
}


get(name) %>% select(c(1:6), all$fileName) %>% 
  fwrite(file_in(output_file),
         sep = '\t', quote=F,row.names=F)

