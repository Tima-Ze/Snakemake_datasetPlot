rule all:
    input: "Metadata/plot.done"
	
rule plot_meta:
	input:
		"Metadata/{}.csv"
	output:
		touch("Metadata/plot.done")
	condaname:
        	"R" 
	Script:
		"Scripts/Meta/plot.R"
