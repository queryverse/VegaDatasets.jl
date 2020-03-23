using Documenter, VegaDatasets

makedocs(
	modules = [VegaDatasets],
	sitename = "VegaDatasets.jl",
	analytics = "UA-132838790-1",
	pages = [
        "Introduction" => "index.md"
    ]
)

deploydocs(
    repo = "github.com/queryverse/VegaDatasets.jl.git"
)
