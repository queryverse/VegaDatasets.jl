__precompile__()
module VegaDatasets

using DataFrames, JSON, TextParse, Missings

export dataset

function dataset(name::AbstractString)
    json_filename = joinpath(@__DIR__,"..","data", "data", "$name.json")
    csv_filename = joinpath(@__DIR__,"..","data","data", "$name.csv")
    if isfile(json_filename)
        json_data = JSON.parsefile(json_filename)

        #Iterate over all JSON elements, get keys, then take distinct keys
        colnames = unique(vcat([collect(keys(d)) for d in json_data]...))

        #Get column types
        coltypes = Type[]
        for col in colnames
            col_type = typeof(get(json_data[1], col, Missings.missing))
            for row in 2:length(json_data)
                col_type = Base.promote_type(col_type, typeof(get(json_data[row], col, Missings.missing)))
            end
            push!(coltypes, col_type)
        end

        df = DataFrame(coltypes, convert(Vector{Symbol}, colnames), 0)

        for row in json_data
            push!(df, ( [get(row, col, Missings.missing) for col in colnames]... ))
        end
        return df
    elseif isfile(csv_filename)
        data, header = csvread(csv_filename)

        return DataFrame([data...], [Symbol(i) for i in header])
    else
        error("Unknown dataset.")
    end
end

end # module
