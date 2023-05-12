configfile: "config/config.yaml"
rule polish&select
	input":featurecount=expand("counts/featurecount/raw_featurecount/{id}.txt",id=config["Samples"])
rule plot:
	input:
		"Metadata/{}.csv"
	output:
	Script:
		"Scripts/Meta/plot.R"
