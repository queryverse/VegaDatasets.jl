using VegaDatasets
import IteratorInterfaceExtensions, TableTraits, TableShowUtils
using Base.Test

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
