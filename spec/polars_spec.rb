# frozen_string_literal: true

RSpec.describe Polars::DataFrame do
  rdata_directory = File.expand_path("../data/csv", __dir__)
  Dir.glob(File.join(rdata_directory, "*/")).sort.each do |dirpath|
    package = File.basename(dirpath)

    Dir.glob(File.join(dirpath, "*")).sort.each do |filepath|
      dataset = File.basename(filepath, ".csv.gz")

      it "can load the #{package}/#{dataset} dataset with String" do
        expect(Polars::DataFrame.from_rdatasets(package, dataset).class).to eq Polars::DataFrame
      end

      it "can load the #{package}/#{dataset} dataset with Symbol" do
        expect(Polars::DataFrame.from_rdatasets(package.to_sym, dataset.to_sym).class).to eq Polars::DataFrame
      end
    end
  end
end
