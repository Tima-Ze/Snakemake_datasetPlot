rule plot_meta:
	input:
		"Metadata/{}.csv"
	output:
	Script:
		"Scripts/Meta/plot.R"
