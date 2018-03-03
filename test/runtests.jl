using VegaDatasets
using DataFrames
using Base.Test

@testset "VegaDatasets" begin

df = dataset("iris")

@test isa(df, DataFrame)

df2 = dataset("airports")

@test isa(df2, DataFrame)

@test_throws ErrorException dataset("doesnotexist")

end
