using Documenter, VegaDatasets

makedocs(
	modules=[VegaDatasets],
	sitename="VegaDatasets.jl",
	format = Documenter.HTML(analytics = "UA-132838790-1"),
	warnonly = [:missing_docs],
	pages=[
        "Introduction" => "index.md"
    ]
)

deploydocs(
    repo="github.com/queryverse/VegaDatasets.jl.git"
)
