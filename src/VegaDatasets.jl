__precompile__()
module VegaDatasets

using DataFrames, JSON, TextParse, Missings

export dataset

function load_json(filename)
    json_data = JSON.parsefile(filename)

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
end

function load_csv(filename)
    data, header = csvread(filename)

    return DataFrame([data...], [Symbol(i) for i in header])
end

function dataset(name::AbstractString)
    if isfile(joinpath(@__DIR__,"..","data", "data", name))
        if splitext(name)[2]==".csv"
            return load_csv(joinpath(@__DIR__,"..","data", "data", name))
        elseif splitext(name)[2]==".json"
            return load_json(joinpath(@__DIR__,"..","data", "data", name))
        else
            error("Unknown dataset.")
        end 
    else
        json_filename = joinpath(@__DIR__,"..","data", "data", "$name.json")
        csv_filename = joinpath(@__DIR__,"..","data","data", "$name.csv")
        if isfile(json_filename)
            return load_json(json_filename)
        elseif isfile(csv_filename)
            return load_csv(csv_filename)
        else
            error("Unknown dataset.")
        end
    end
end

end # module
