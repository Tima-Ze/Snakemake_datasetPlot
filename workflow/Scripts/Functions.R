###BOXplot###
BOXplot=function(x){ 
  data=log2(x+1)
  jpeg(output1, quality = 100, width = 1500, height = 1000)
  boxplot(data, las=2, col="gold")
  title(paste("Distribution of log2 count for", sub("\\.jpeg",as.character(Norm_method),basename(output1))))
  dev.off()
  print(sub("\\.jpeg","",basename(output1)), "Box Plot done!")
}

###BarPlot####
BARplot=function(x){
  jpeg(output2, quality = 100, width = 1500, height = 1000)
  par(mar=c(15,7,5,8))
  barplot(colSums(df), names=colnames(df),  horiz=TRUE,las=2, xlab="library size", col="lightpink",
          col.axis="Darkblue", 
          cex.names =1 )
  title(sub("\\.jpeg",as.character(Norm_method),basename(output2)))
  dev.off()
  print(sub("\\.jpeg",as.character(Norm_method),basename(output2)), "Bar Plot done!")
}

###PCA####
plotPCA=function(x) {
  tmp=ls(pattern = "*_meta") %>% purrr::reduce(rbind) %>% 
    select(fileName, all_of(PCA_color)) %>%
    tibble::column_to_rownames('fileName')
  df=merge(x, tmp, by=0 )
  rownames(df)<-df$Row.name
  df$Row.names<-NULL
  pca=prcomp(log(df[, -which(names(df) %in% PCA_color)]+1), scale=T)
  autoplot(pca,
           data=df,colour='condition' ,shape='SEX', 
           size=3.2, label =F , label.size = 4, frame = TRUE)+
    geom_text(aes(label=rownames(df)), nudge_y = -0.01)+
    labs(title=sub("\\.jpeg",as.character(Norm_method),basename(output2)))+
    scale_fill_brewer(palette="Set1")+
    theme_bw()+
    expand_limits(x=c(-0.5,0.35), y=c(-0.35, 0.4))
  
  ggsave(output3,  plot = last_plot(),  width = 30, height = 20, units = "cm", bg = 'white')
  print(xsub("\\.jpeg",as.character(Norm_method),basename(output2)), "PCA Plot done!") 
}

####This function checks directories####
check_and_create_dir <- function(path, f) {
  if (!dir.exists(file.path(path, f))) {
    dir.create(file.path(path, f), recursive = TRUE)
    print(paste0("Directory ", path, " created"))
  } else {
    print(paste0("Directory ", path, " exists"))
  }
}