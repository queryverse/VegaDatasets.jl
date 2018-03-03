# VegaDatasets

[![Project Status: Active - The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
[![Build Status](https://travis-ci.org/davidanthoff/VegaDatasets.jl.svg?branch=master)](https://travis-ci.org/davidanthoff/VegaDatasets.jl)
[![Build status](https://ci.appveyor.com/api/projects/status/0ph04s8d5r7jqf0p/branch/master?svg=true)](https://ci.appveyor.com/project/davidanthoff/vegadatasets-jl/branch/master)
[![VegaDatasets](http://pkg.julialang.org/badges/VegaDatasets_0.6.svg)](http://pkg.julialang.org/?pkg=VegaDatasets)
[![codecov](https://codecov.io/gh/davidanthoff/VegaDatasets.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/davidanthoff/VegaDatasets.jl)


## Overview

This package provides an easy way to load the datasets in
[vega-datasets](https://github.com/vega/vega-datasets) from julia.

## Installation

You can install this package from the julia REPL with the following
command:

````julia
Pkg.add("https://github.com/davidanthoff/VegaDatasets.jl.git")
````

## Getting started

The package only exports one function that takes the name of a dataset
and returns a ``DataFrame`` with that data:

````julia
using VegaDatasets

df = dataset("iris")
````
