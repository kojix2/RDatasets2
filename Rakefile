# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "open-uri"
require "zip"
require "fileutils"

RSpec::Core::RakeTask.new(:spec)

task default: :spec

namespace :data do
  desc "Download, unzip, organize, and compress Rdatasets"
  task :prepare do
    url = "https://github.com/vincentarelbundock/Rdatasets/archive/master.zip"
    zip_path = "master.zip"
    destination_dir = "data"

    # Download ZIP file
    puts "Downloading Rdatasets..."
    URI.open(url) do |data|
      File.open(zip_path, "wb") do |file|
        file.write(data.read)
      end
    end

    # Unzip the file
    puts "Unzipping..."
    Zip::File.open(zip_path) do |zip_file|
      zip_file.each do |entry|
        entry.extract(entry.name) { true } # Overwrite if necessary
      end
    end

    # Clean up and prepare directories
    FileUtils.rm(zip_path)
    FileUtils.rm_rf(destination_dir)
    FileUtils.mkdir_p(destination_dir)
    FileUtils.cp_r("Rdatasets-master/csv/", destination_dir)
    FileUtils.cp("Rdatasets-master/datasets.csv", "#{destination_dir}/datasets.csv")
    FileUtils.rm_rf("Rdatasets-master")

    # Compress CSV files
    puts "Compressing CSV files..."
    Dir.glob("#{destination_dir}/**/*.csv").each do |file|
      Zlib::GzipWriter.open("#{file}.gz") do |gz|
        gz.write IO.binread(file)
      end
      FileUtils.rm(file)
    end

    puts "Rdatasets prepared."
  end
end

desc "Prepare Rdatasets"
task prepare_rdatasets: "data:prepare"
