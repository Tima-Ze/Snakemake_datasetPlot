# Snakemake_datasetPlot
Inputdata:
1-Featurecount output which is stored as "counts/featurecount/raw_featurecount/{datasets_name}/{rawCounts_name}.txt"
2-Metadata which should be stored as "Metadata/{datasets_name}/{MetaDdata_name}.csv":
Metadata should have this column names: fileName  condition
I made this snakefile to produce all plots for my Bulk RNAseq data: MSBB dataset and MayoRNAseq.
Plots:
1-Age and sex distribution plot for all datasets
2-...
