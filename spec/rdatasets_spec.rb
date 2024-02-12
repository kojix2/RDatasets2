# frozen_string_literal: true

RSpec.describe Rdatasets do
  it "has a version number" do
    expect(Rdatasets::VERSION).not_to be nil
  end

  it "show a list of packages" do
    expect(Rdatasets.df.class).to eq Polars::DataFrame
  end

  it "can set index" do
    df = Rdatasets.load :datasets, :iris
    expect(df[0].to_a).not_to eq Array.new(df.size) { |i| i + 1 }
  end

  it 'can search "diamond"' do
    df = Rdatasets.search "diamond"
    expect(df.size).to eq 4
  end

  it "can search /ing$/" do
    df = Rdatasets.search(/ing$/)
    # 41 was confirmed by LibreOffice Calc.
    expect(df.size).to eq 42
  end

  it "can load datasets with method chain" do
    df1 = Rdatasets.load :datasets, :iris
    df2 = Rdatasets.datasets.iris
    expect(df1 == df2).to eq true
  end

  it "dose not respond to the wrong package name" do
    expect(Rdatasets.respond_to?(:wrong_package_name)).to be false
    expect { Rdatasets.respond_to?(3) }.to raise_error(TypeError)
  end

  rdata_directory = File.expand_path("../data/csv", __dir__)
  Dir.glob(File.join(rdata_directory, "*/")).sort.each do |dirpath|
    package = File.basename(dirpath)

    it "respond to the package name #{package}" do
      expect(Rdatasets.respond_to?(package)).to be true
    end

    package_object = Rdatasets.public_send(package)

    it "dose not respond to the wrong dataset name" do
      expect(package_object.respond_to?(:wrong_dataset_name)).to be false
      expect { package_object.respond_to?(3) }.to raise_error(TypeError)
    end

    Dir.glob(File.join(dirpath, "*")).sort.each do |filepath|
      dataset = File.basename(filepath, ".csv.gz")

      # https://github.com/vincentarelbundock/Rdatasets/issues/8
      # https://github.com/allisonhorst/palmerpenguins/issues/80
      next if dataset == "penguins_raw"

      it "respond to the dataset name #{dataset} in #{package}" do
        expect(package_object.respond_to?(dataset)).to be true
      end

      it "can load the #{package}/#{dataset} dataset with String" do
        expect(Rdatasets.load(package, dataset)).to be_an_instance_of Polars::DataFrame
      end

      it "can load the #{package}/#{dataset} dataset with Symbol" do
        expect(Rdatasets.load(package.to_sym, dataset.to_sym)).to be_an_instance_of Polars::DataFrame
      end

      it "can load the #{package}/#{dataset} dataset with method chain" do
        # WHY `public_send` ?
        # `send` can call private methods.
        # This cause trouble especially when calling `sleep`.
        expect(Rdatasets.public_send(package.to_sym)
                        .public_send(dataset.to_sym)).to be_an_instance_of Polars::DataFrame
      end
    end
  end
end
