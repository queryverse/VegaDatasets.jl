# VegaDatasets

[![Project Status: Active - The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
[![Build Status](https://travis-ci.org/queryverse/VegaDatasets.jl.svg?branch=master)](https://travis-ci.org/queryverse/VegaDatasets.jl)
[![Build status](https://ci.appveyor.com/api/projects/status/ad1mcex5tjbe160r/branch/master?svg=true)](https://ci.appveyor.com/project/queryverse/vegadatasets-jl/branch/master)
[![VegaDatasets](http://pkg.julialang.org/badges/VegaDatasets_0.6.svg)](http://pkg.julialang.org/?pkg=VegaDatasets)
[![codecov](https://codecov.io/gh/queryverse/VegaDatasets.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/queryverse/VegaDatasets.jl)


## Overview

This package provides an easy way to load the datasets in [vega-datasets](https://github.com/vega/vega-datasets) from julia.

## Installation

You can install this package from the julia REPL with the following command:

````julia
Pkg.add("VegaDatasets")
````

## Getting started

The package only exports one function that takes the name of a dataset and returns a ``VegaDataset`` with that data:

````julia
using VegaDatasets

vg = dataset("iris")
````

``VegaDataset`` implements the [iterable tables](https://github.com/queryverse/IterableTables.jl) interface, so it can be passed to any sink that accepts iterable tables.

For example, to convert a dataset into a ``DataFrame``, you can write:

````julia
using VegaDatasets, DataFrames

df = DataFrame(dataset("iris"))
````

You can pipe a ``VegaDataset`` directly into a [VegaLite.jl](https://github.com/fredo-dedup/VegaLite.jl) plot:

````julia
using VegaLite, VegaDatasets

dataset("iris") |> @vlplot(:point, x=:sepalLength, y=:petalWidth)
````
