using VegaDatasets
using DataFrames
using Base.Test

@testset "VegaDatasets" begin

df = dataset("iris")

@test isa(df, DataFrame)
end
