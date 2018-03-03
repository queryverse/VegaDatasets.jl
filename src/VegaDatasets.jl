__precompile__()
module VegaDatasets

using DataFrames, JSON, TextParse

export dataset

function dataset(name::AbstractString)
    json_filename = joinpath(@__DIR__,"..","data", "data", "$name.json")
    csv_filename = joinpath(@__DIR__,"..","data","data", "$name.csv")
    if isfile(json_filename)
        json_data = JSON.parsefile(json_filename)
        colnames = collect(Symbol(i) for i in keys(json_data[1]))

        coltypes = Type[]
        for col in colnames
            col_type = typeof(json_data[1][String(col)])
            for row in 2:length(json_data)
                col_type = Base.promote_type(col_type, typeof(json_data[row][String(col)]))
            end
            push!(coltypes, col_type)
        end

        df = DataFrame(coltypes, colnames, 0)

        for row in json_data
            push!(df, ( [row[String(col)] for col in colnames]... ))
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
