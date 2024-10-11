
# Snakemake_datasetPlot
## Overview

I created this Snakefile to produce all plots for my Bulk RNAseq data, specifically for the **MSBB** dataset and **MayoRNAseq**.

## Plots

1. **Age and Sex Distribution Plot** for all datasets
2. **...**

## Input Data

1. **FeatureCount Output**: This should be stored as 
counts/featurecount/raw_featurecount/{datasets_name}/{rawCounts_name}.txt

2. **Metadata**: This should be stored as 
Metadata/{datasets_name}/{Metadata_name}.csv

- The metadata file should contain the following column names:
  - `fileName`
  - `condition`

