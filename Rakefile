require 'jekyll'
require 'shellwords'
require 'tmpdir'
require 'fileutils'
require './countries_data_parser'

GITHUB_REPONAME = "watershedlegal/mapping-laws"

task :default => [:publish]

desc "Generate and publish blog"
task :publish do
  message = "Site updated at #{Time.now.utc}"
  system "git checkout -- _config.yml"
  Jekyll::Site.new(Jekyll.configuration({
    "source"      => ".",
    "destination" => "_site"
  })).process
  parse_the_countries_data
  system "git add -A"
  system "git commit -m #{message.shellescape}"
  system "git push github master"
  system "git push wsl master"
  Dir.mktmpdir do |tmp|
    FileUtils.cp_r "_site/.", tmp
    Dir.chdir tmp
    system "git init"
    system "git add ."
    message = "Site updated at #{Time.now.utc}"
    system "git commit -m #{message.shellescape}"
    system "git remote add origin git@github.com:#{GITHUB_REPONAME}.git"
    system "git push origin master:gh-pages --force"
  end
end

desc "Local Testing"
task :test do
  parse_the_countries_data true
  index_file = File.join(File.dirname(__FILE__) + '/index.html')
  system "google-chrome #{index_file}"
end

desc "Deploy Demo"
task :demo do
  parse_the_countries_data true
  Rake::Task['publish'].invoke
end