using VegaDatasets
using Base.Test

@testset "VegaDatasets" begin

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
