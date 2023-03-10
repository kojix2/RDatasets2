# RDatasets
[![Gem Version](https://badge.fury.io/rb/rdatasets.svg)](https://badge.fury.io/rb/rdatasets)
[![Build Status](https://github.com/kojix2/RDatasets/workflows/test/badge.svg)](https://github.com/kojix2/RDatasets/actions)

RDatasets for Ruby.
This ruby gem allows you to access over 1200 datasets included in R from Ruby.

- All the datasets were imported from [RDatasets](https://github.com/vincentarelbundock/Rdatasets) created by Vincent.
- This Ruby gem was inspired by [RDatasets.jl](https://github.com/johnmyleswhite/RDatasets.jl) created by John Myles White.

## Installation

```bash
gem install rdatasets
```

## Usage

```ruby
require 'rdatasets'
df = RedAmber::DataFrame.from_rdatasets("datasets","iris")
df = RDatasets.load "datasets", "iris"
df = RDatasets.load :datasets, :iris
df = RDatasets.datasets.iris
# returns RedAmber::DataFrame

# available datasets
df = RDatasets.df

# search
RDatasets.search "diamonds"
RDatasets.search /diamonds/
```

## Development
- Do not add data other than the CSV file.
- Do not add custom useful methods for a specific dataset.

## Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/kojix2/rdatasets.

    Do you need commit rights to my repository?
    Do you want to get admin rights and take over the project?
    If so, please feel free to contact me @kojix2.

## License
GPL-3. See the documents below for more details.
- https://github.com/vincentarelbundock/Rdatasets#license
- https://github.com/johnmyleswhite/RDatasets.jl#licensing-and-intellectual-property
