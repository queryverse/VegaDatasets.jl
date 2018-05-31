using VegaDatasets
using Base.Test

@testset "VegaDatasets" begin

for filename in readdir(joinpath(@__DIR__,"..","data","data"))
    if splitext(filename)[2]==".json" || splitext(filename)[2]==".csv"
        if !in(splitdir(filename)[2], ["earthquakes.json", "graticule.json", "londonBoroughs.json", "londonTubeLines.json", "miserables.json", "sf-temps.csv", "us-10m.json", "world-110m.json"])
            vd = dataset(filename)

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

df3 = dataset("weather.csv")

@test isa(df3, VegaDatasets.VegaDataset)

df4 = dataset("weather.json")

@test isa(df4, VegaDatasets.VegaDataset)

end
