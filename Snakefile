rule plot:
	input:
		"Metadata/{}.csv"
	output:
	Script:
		"Scripts/Meta/plot.R"
