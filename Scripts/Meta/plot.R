library(dplyr)
library(ggplot2)

if(!dir.exists('plot')) {
  dir.create('plot')
}  
for (i in snakemake@input) {
  assign(sub("[.]csv", "", i), read.csv(i))
}
rm(i)
name=ls()
df=data.frame()
for (i in name) {
  d=data.frame(data=i,
               Sex=get(i)$SEX)
  df=rbind(df, d)
}
rm(i,d)

df$data<-factor(df$data, levels = name)

df=df %>% 
  group_by(data) %>% 
  count(Sex)

df=df %>% 
  mutate(Group=case_when(
    (data=='AD_msbbBM10'| data=='control_msbbBM10' ~ 'Dataset1'),
    (data=="AD_msbbBM22" |data==  "control_msbbBM22" ~ 'Dataset2'),
    (data=="AD_msbbBM36"|data== "control_msbbBM36" ~ 'Dataset3'),
    (data=="AD_msbbBM44"|data== "control_msbbBM44" ~ 'Dataset4'),
    (data=="AD_mayo_TCX" |data== "control_mayo_TCX" ~ 'Dataset5'),
    (data=="AD_mayo_CER"|data==  "control_mayo_CER" ~ 'Dataset6'),
    
  ))

ggplot(df, aes(x=data, y=n, fill=Sex))+
  geom_bar(stat = 'identity', position=position_dodge())+
  facet_grid(.~ Group, switch = "both", scales = 'free')+
  ylab("Sex Distribution")+
  theme(panel.background = element_rect(fill="grey80"),
        strip.placement = "outside",
        panel.spacing = unit(0, "lines"),
        axis.title.x = element_blank(),
        axis.text.x = element_text(size = 12, angle = 60, hjust = 1),
        axis.title.y = element_text(size = 16),
        axis.text = element_text(size = 15),
        legend.text = element_text(size = 15))+
  theme(panel.spacing = unit(2, "lines"))+
  ylim(0,30)

  
ggsave("plot/Sex_barplot.jpg",  plot = last_plot(),  width = 1500, height = 1000)
