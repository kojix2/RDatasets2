# Rdatasets
[![Gem Version](https://badge.fury.io/rb/rdatasets.svg)](https://badge.fury.io/rb/rdatasets)
[![Build Status](https://github.com/kojix2/Rdatasets/workflows/test/badge.svg)](https://github.com/kojix2/Rdatasets/actions)

Rdatasets for Ruby.
This ruby gem allows you to access over 1200 datasets included in R from Ruby.

- All the datasets were imported from [Rdatasets](https://github.com/vincentarelbundock/Rdatasets) created by Vincent.
- This Ruby gem was inspired by [Rdatasets.jl](https://github.com/johnmyleswhite/Rdatasets.jl) created by John Myles White.

## Installation

```bash
gem install rdatasets
```

## Usage

```ruby
require "rdatasets"
df = Polars::DataFrame.from_rdatasets("datasets","iris")
df = Rdatasets.load "datasets", "iris"
df = Rdatasets.load :datasets, :iris
df = Rdatasets.datasets.iris
# returns Polars::DataFrame

# available datasets
df = Rdatasets.df

# search
Rdatasets.search "diamonds"
Rdatasets.search /diamonds/
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
- https://github.com/johnmyleswhite/Rdatasets.jl#licensing-and-intellectual-property
