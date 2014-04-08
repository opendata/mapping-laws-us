#!/usr/bin/env ruby
require 'yaml'
require 'json'


def parse_the_countries_data
  # Set the Defaults
  country_data               = {}
  countries_data_header      = 'var countriesData = '
  country_data_template_file = './countries_data.js'

  # Load the YAML Front Matter
  files = Dir.glob("./countries/*.md")
  files.each do |file|
    data = YAML.load(File.read(file)[/---(.|\n)*---/])
    country_data[data['country_id'].to_s] = {'rank' => data['country_rank'], 'synopsis' => data['synopsis']}
  end

  # Load the Template File
  country_data_template = File.read(country_data_template_file)
  country_data_template.gsub!(countries_data_header, '')
  country_data_template = JSON.parse(country_data_template)

  # Dump the Collated Data into the Template File
  country_data.each do |cdat|
    cdts = country_data_template['features'].select{|cdt| cdt['id'] == cdat[0]}.first
    cdts['properties'] = cdat[1]
  end

  # Save the Template File
  country_data_to_save = countries_data_header + JSON.dump(country_data_template)
  File.open(country_data_template_file, 'w'){|f| f.write(country_data_to_save)}
end