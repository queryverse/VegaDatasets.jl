module VegaDatasets

using JSON, TextParse, DataValues, TableShowUtils, DataStructures,
    TableTraits, IteratorInterfaceExtensions, TableTraitsUtils, FilePaths
import IterableTables

export dataset

struct VegaDataset
    data::Union{OrderedDict{Symbol,Any},Nothing}
    path::AbstractPath
end

struct VegaJSONDataset
    data::OrderedDict
    path::AbstractPath
end

JSON.lower(x::VegaJSONDataset) = x.data

function Base.show(io::IO, source::VegaJSONDataset)
    print(io, "Vega JSON Dataset")
end

IteratorInterfaceExtensions.isiterable(x::VegaDataset) = true
TableTraits.isiterabletable(x::VegaDataset) = true

function Base.collect(vd::VegaDataset)
    return collect(getiterator(vd))
end

function IteratorInterfaceExtensions.getiterator(file::VegaDataset)
    it = TableTraitsUtils.create_tableiterator(collect(values(file.data)), collect(keys(file.data)))
    return it
end

function Base.show(io::IO, source::VegaDataset)
    if source.data !== nothing
        TableShowUtils.printtable(io, getiterator(source), "Vega dataset")
    end
end

function Base.show(io::IO, ::MIME"text/html", source::VegaDataset)
    if source.data !== nothing
        TableShowUtils.printHTMLtable(io, getiterator(source))
    end
end

Base.Multimedia.showable(::MIME"text/html", source::VegaDataset) = true

function Base.show(io::IO, ::MIME"application/vnd.dataresource+json", source::VegaDataset)
    if source.data !== nothing
        TableShowUtils.printdataresource(io, getiterator(source))
    end
end

Base.Multimedia.showable(::MIME"application/vnd.dataresource+json", source::VegaDataset) = true

function load_json(filename)
    json_data = JSON.parsefile(filename, dicttype = DataStructures.OrderedDict)

    nrows = length(json_data)

    # Iterate over all JSON elements, get keys, then take distinct keys
    colnames = unique(vcat([collect(keys(d)) for d in json_data]...))

    ncols = length(colnames)

    # Get column types
    coltypes = Type[]
    for col in colnames
        curr_T = typeof(get(json_data[1], col, DataValues.NA))
        if curr_T <: Nothing
            curr_T = typeof(DataValues.NA)
        end
        col_type = curr_T

        for row in 2:length(json_data)
            curr_T = typeof(get(json_data[row], col, DataValues.NA))
            if curr_T <: Nothing
                curr_T = typeof(DataValues.NA)
            end
            col_type = Base.promote_type(col_type, curr_T)
        end
        push!(coltypes, col_type)
    end

    coldata = [ct <: DataValue ? DataValueVector{eltype(ct)}(nrows) : Vector{ct}(undef, nrows) for ct in coltypes]

    for (i, row) in enumerate(json_data)
        for colindx in 1:ncols
            v = get(row, colnames[colindx], DataValues.NA)
            if v === nothing
                v = DataValues.NA
            end
            coldata[colindx][i] = v
        end
    end

    return VegaDataset(OrderedDict{Symbol,Any}(Symbol(i[1]) => i[2] for i in zip(colnames, coldata)), Path(normpath(filename)))
end

function load_csv(filename; delim = ',')
    data, header = csvread(filename, delim)

    return VegaDataset(OrderedDict{Symbol,Any}(Symbol(i[1]) => i[2] for i in zip(header, data)), Path(normpath(filename)))
end

function dataset(name::AbstractString)
    if in(name, ["sf-temps"])
        error("This dataset is currently not supported.")
    elseif in(name, ["earthquakes", "graticule", "londonBoroughs", "londonTubeLines", "miserables", "us-10m", "world-110m"])
        json_filename = normpath(joinpath(@__DIR__, "..", "data", "data", "$name.json"))
        return VegaJSONDataset(JSON.parsefile(json_filename, dicttype = DataStructures.OrderedDict), Path(json_filename))
    elseif isfile(joinpath(@__DIR__, "..", "data", "data", name))
        if splitext(name)[2] == ".csv"
            return load_csv(joinpath(@__DIR__, "..", "data", "data", name))
        elseif splitext(name)[2] == ".tsv"
            return load_csv(joinpath(@__DIR__, "..", "data", "data", name), delim = '\t')
        elseif splitext(name)[2] == ".json"
            return load_json(joinpath(@__DIR__, "..", "data", "data", name))
        else
            error("Unknown dataset.")
        end
    else
        json_filename = joinpath(@__DIR__, "..", "data", "data", "$name.json")
        csv_filename = joinpath(@__DIR__, "..", "data", "data", "$name.csv")
        tsv_filename = normpath(joinpath(@__DIR__, "..", "data", "data", "$name.tsv"))
        if isfile(json_filename)
            return load_json(json_filename)
        elseif isfile(csv_filename)
            return load_csv(csv_filename)
        elseif isfile(tsv_filename)
            return load_csv(tsv_filename, delim = '\t')
        else
            error("Unknown dataset.")
        end
    end
end

end # module
