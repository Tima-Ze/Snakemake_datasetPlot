rule plot_meta:
	input:
		"Metadata/{}.csv"
	output:
	condaname:
        	"R" 
	Script:
		"Scripts/Meta/plot.R"
