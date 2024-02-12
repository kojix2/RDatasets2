# frozen_string_literal: true

require "rdatasets/version"

require "polars"
require "zlib"

# Module for Rdatasets
module Rdatasets
  # R packages.
  class Package
    attr_reader :package_name

    def initialize(package_name)
      @package_name = package_name
      @datasets = Rdatasets.package package_name
    end

    private

    def method_missing(name)
      return Rdatasets.load @package_name, name if @datasets.include? name

      super
    end

    def respond_to_missing?(name, include_private)
      @datasets.include?(name) ? true : super
    end
  end

  private_constant :Package

  def self.method_missing(package_name)
    return Package.new(package_name) if Rdatasets.packages.include? package_name

    super
  end

  def self.respond_to_missing?(package_name, include_private)
    Rdatasets.packages.include?(package_name) ? true : super
  end

  module_function

  # Load a certain dataset and returns a dataframe.
  # @param package_name [String, Symbol] :R package name
  # @param dataset_name [String, Symbol] :R dataset name
  # @return [Polars::DataFrame]
  def load(package_name, dataset_name = nil)
    if dataset_name
      file_path = get_file_path(package_name, dataset_name)
      raise "No such file -- #{file_path}" unless File.exist?(file_path)

      read_gzip_dataframe(file_path) # Refactored to use helper method
    else
      package(package_name)
    end
  end

  def read_gzip_dataframe(file_path)
    Zlib::GzipReader.open(file_path) do |gz|
      Polars.read_csv(gz, infer_schema_length: 10_000)
    end
  rescue StandardError => e
    raise "Failed to read Gzip file: #{e.message}"
  end

  # Get the file path of a certain dataset.
  # @param package_name [String, Symbol] :R package name
  # @param dataset_name [String, Symbol] :R dataset name
  # @return [String]
  def get_file_path(package_name, dataset_name)
    rdata_directory = File.expand_path("../data/csv", __dir__)
    package_name = package_name.to_s if package_name.is_a? Symbol
    dataset_name = dataset_name.to_s if dataset_name.is_a? Symbol

    # "car" package directory is a symbolic link.
    # Do not use Symbolic links because they can cause error on Windows.
    package_name = "carData" if package_name == "car"
    dataset_name += ".csv.gz"
    File.join(rdata_directory, package_name, dataset_name)
  end

  # Display information of all data sets.
  # @return [Polars::DataFrame]
  def df
    file_path = File.expand_path("../data/datasets.csv.gz", __dir__)
    read_gzip_dataframe(file_path) # Use the refactored helper method
  end

  # Show a list of all packages.
  # @return [Array<Symbol>]
  def packages
    df["Package"].to_a.uniq.map(&:to_sym)
  end

  # Show a list of datasets included in the package.
  # @param [String, Symbol] :R package name
  # @return [Array<Symbol>]
  def package(package_name)
    ds = df[Polars.col("Package") == package_name.to_s]
    ds["Item"].to_a.map(&:to_sym)
  end

  # Search available datasets. (items and titles)
  # If the argument is a string, ignore case.
  # @param pattern [String, Regexp] :The pattern to search for
  # @return [Polars::DataFrame]
  def search(pattern)
    case pattern
    when String
      "(?-mix:#{pattern})"
    when Regexp
      pattern = pattern.to_s if pattern.is_a? Regexp
    else
      raise ArgumentError, "Invalid argument type: #{pattern.class}"
    end
    df.filter((Polars.col("Item").str.contains(pattern)) | (Polars.col("Title").str.contains(pattern)))
  end
end

module Polars
  class DataFrame
    # Read a certain dataset from the Rdatasets and returns a dataframe.
    # @param package_name [String, Symbol] :R package name
    # @param dataset_name [String, Symbol] :R dataset name
    # @return [Polars::DataFrame]
    def self.from_rdatasets(package_name, dataset_name)
      Rdatasets.load(package_name, dataset_name)
    end
  end
end
