using VegaDatasets
import IteratorInterfaceExtensions, TableTraits, TableShowUtils
using Test

@testset "VegaDatasets" begin

for filename in readdir(joinpath(@__DIR__,"..","data","data"))
    if splitext(filename)[2]==".json" || splitext(filename)[2]==".csv"
        if !in(splitdir(filename)[2], ["earthquakes.json", "graticule.json", "londonBoroughs.json", "londonTubeLines.json", "miserables.json", "sf-temps.csv", "us-10m.json", "world-110m.json"])
            vd = dataset(filename)

            @test IteratorInterfaceExtensions.isiterable(vd) == true
            @test TableTraits.isiterabletable(vd) == true

            cvd = collect(vd)

            @test isa(cvd, Array)
        end
    end
end

df = dataset("iris")

@test isa(df, VegaDatasets.VegaDataset)

df2 = dataset("airports")

@test isa(df2, VegaDatasets.VegaDataset)

@test_throws ErrorException dataset("doesnotexist")

@test_throws ErrorException dataset("7zip.png")

df3 = dataset("weather.csv")

@test isa(df3, VegaDatasets.VegaDataset)

df4 = dataset("weather.json")

@test isa(df4, VegaDatasets.VegaDataset)

@test sprint(show, dataset("lookup_groups")) == """
9x2 Vega dataset
group │ person
──────┼───────
1     │ Alan  
1     │ George
1     │ Fred  
2     │ Steve 
2     │ Nick  
2     │ Will  
3     │ Cole  
3     │ Rick  
3     │ Tom   """

end

@testset "Show" begin

cars = dataset("cars")
@test sprint((stream,data)->show(stream, "text/html", data), cars)[1:300] == "<table><thead><tr><th>Miles_per_Gallon</th><th>Cylinders</th><th>Origin</th><th>Weight_in_lbs</th><th>Displacement</th><th>Acceleration</th><th>Name</th><th>Year</th><th>Horsepower</th></tr></thead><tbody><tr><td>18.0</td><td>8</td><td>&quot;USA&quot;</td><td>3504</td><td>307.0</td><td>12.0</td><td>"
@test sprint((stream,data)->show(stream, "application/vnd.dataresource+json", data), cars)[1:300] == "{\"schema\":{\"fields\":[{\"name\":\"Miles_per_Gallon\",\"type\":\"number\"},{\"name\":\"Cylinders\",\"type\":\"integer\"},{\"name\":\"Origin\",\"type\":\"string\"},{\"name\":\"Weight_in_lbs\",\"type\":\"integer\"},{\"name\":\"Displacement\",\"type\":\"number\"},{\"name\":\"Acceleration\",\"type\":\"number\"},{\"name\":\"Name\",\"type\":\"string\"},{\"name\":\""
@test showable("text/html", cars) == true
@test showable("application/vnd.dataresource+json", cars) == true

earthquakes = dataset("earthquakes")
graticule = dataset("graticule")
londonBoroughs = dataset("londonBoroughs")
londonTubeLines = dataset("londonTubeLines")
miserables = dataset("miserables")
sf_temps = dataset("sf-temps")
us_10m = dataset("us-10m")
world_110m = dataset("world-110m")
@test sprint(show, earthquakes) == ""
@test sprint(show, graticule) == ""
@test sprint(show, londonBoroughs) == ""
@test sprint(show, londonTubeLines) == ""
@test sprint(show, miserables) == ""
@test sprint(show, sf_temps) == ""
@test sprint(show, us_10m) == ""
@test sprint(show, world_110m) == ""

end
