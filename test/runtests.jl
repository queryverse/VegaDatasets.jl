using VegaDatasets
import IteratorInterfaceExtensions, TableTraits, TableShowUtils, FilePaths
using Test

@testset "VegaDatasets" begin

    @testset "Core" begin

        for filename in readdir(joinpath(@__DIR__, "..", "data", "data"))
            if splitext(filename)[2] == ".json" || splitext(filename)[2] == ".csv"
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

        @test sprint(show, dataset("lookup_groups")) == "9x2 Vega dataset\ngroup │ person\n──────┼───────\n1     │ Alan  \n1     │ George\n1     │ Fred  \n2     │ Steve \n2     │ Nick  \n2     │ Will  \n3     │ Cole  \n3     │ Rick  \n3     │ Tom   "

    end

    @testset "Show" begin

        cars = dataset("cars")
        @test sprint((stream, data)->show(stream, "text/html", data), cars) == "<table><thead><tr><th>Name</th><th>Miles_per_Gallon</th><th>Cylinders</th><th>Displacement</th><th>Horsepower</th><th>Weight_in_lbs</th><th>Acceleration</th><th>Year</th><th>Origin</th></tr></thead><tbody><tr><td>&quot;chevrolet chevelle malibu&quot;</td><td>18.0</td><td>8</td><td>307.0</td><td>130</td><td>3504</td><td>12.0</td><td>&quot;1970-01-01&quot;</td><td>&quot;USA&quot;</td></tr><tr><td>&quot;buick skylark 320&quot;</td><td>15.0</td><td>8</td><td>350.0</td><td>165</td><td>3693</td><td>11.5</td><td>&quot;1970-01-01&quot;</td><td>&quot;USA&quot;</td></tr><tr><td>&quot;plymouth satellite&quot;</td><td>18.0</td><td>8</td><td>318.0</td><td>150</td><td>3436</td><td>11.0</td><td>&quot;1970-01-01&quot;</td><td>&quot;USA&quot;</td></tr><tr><td>&quot;amc rebel sst&quot;</td><td>16.0</td><td>8</td><td>304.0</td><td>150</td><td>3433</td><td>12.0</td><td>&quot;1970-01-01&quot;</td><td>&quot;USA&quot;</td></tr><tr><td>&quot;ford torino&quot;</td><td>17.0</td><td>8</td><td>302.0</td><td>140</td><td>3449</td><td>10.5</td><td>&quot;1970-01-01&quot;</td><td>&quot;USA&quot;</td></tr><tr><td>&quot;ford galaxie 500&quot;</td><td>15.0</td><td>8</td><td>429.0</td><td>198</td><td>4341</td><td>10.0</td><td>&quot;1970-01-01&quot;</td><td>&quot;USA&quot;</td></tr><tr><td>&quot;chevrolet impala&quot;</td><td>14.0</td><td>8</td><td>454.0</td><td>220</td><td>4354</td><td>9.0</td><td>&quot;1970-01-01&quot;</td><td>&quot;USA&quot;</td></tr><tr><td>&quot;plymouth fury iii&quot;</td><td>14.0</td><td>8</td><td>440.0</td><td>215</td><td>4312</td><td>8.5</td><td>&quot;1970-01-01&quot;</td><td>&quot;USA&quot;</td></tr><tr><td>&quot;pontiac catalina&quot;</td><td>14.0</td><td>8</td><td>455.0</td><td>225</td><td>4425</td><td>10.0</td><td>&quot;1970-01-01&quot;</td><td>&quot;USA&quot;</td></tr><tr><td>&quot;amc ambassador dpl&quot;</td><td>15.0</td><td>8</td><td>390.0</td><td>190</td><td>3850</td><td>8.5</td><td>&quot;1970-01-01&quot;</td><td>&quot;USA&quot;</td></tr><tr><td>&vellip;</td><td>&vellip;</td><td>&vellip;</td><td>&vellip;</td><td>&vellip;</td><td>&vellip;</td><td>&vellip;</td><td>&vellip;</td><td>&vellip;</td></tr></tbody></table><p>... with 396 more rows.</p>"
        @test sprint((stream, data)->show(stream, "application/vnd.dataresource+json", data), cars)[1:300] == "{\"schema\":{\"fields\":[{\"name\":\"Name\",\"type\":\"string\"},{\"name\":\"Miles_per_Gallon\",\"type\":\"number\"},{\"name\":\"Cylinders\",\"type\":\"integer\"},{\"name\":\"Displacement\",\"type\":\"number\"},{\"name\":\"Horsepower\",\"type\":\"integer\"},{\"name\":\"Weight_in_lbs\",\"type\":\"integer\"},{\"name\":\"Acceleration\",\"type\":\"number\"},{\"na"
        @test showable("text/html", cars) == true
        @test showable("application/vnd.dataresource+json", cars) == true

        earthquakes = dataset("earthquakes")
        graticule = dataset("graticule")
        londonBoroughs = dataset("londonBoroughs")
        londonTubeLines = dataset("londonTubeLines")
        miserables = dataset("miserables")
# sf_temps = dataset("sf-temps")
        us_10m = dataset("us-10m")
        world_110m = dataset("world-110m")
        @test typeof(earthquakes) <: VegaDatasets.VegaJSONDataset
        @test typeof(graticule) <: VegaDatasets.VegaJSONDataset
        @test typeof(londonBoroughs) <: VegaDatasets.VegaJSONDataset
        @test typeof(londonTubeLines) <: VegaDatasets.VegaJSONDataset
        @test typeof(miserables) <: VegaDatasets.VegaJSONDataset
# @test typeof(sf_temps) <: VegaDatasets.VegaJSONDataset
        @test typeof(us_10m) <: VegaDatasets.VegaJSONDataset
        @test typeof(world_110m) <: VegaDatasets.VegaJSONDataset

    end

end
