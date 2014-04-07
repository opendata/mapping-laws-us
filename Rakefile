require 'jekyll'
require 'shellwords.rb'
require 'tmpdir'

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
  system "git add -A"
  system "git commit -m #{message.shellescape}"
  system "git push github master"
  system "git push wsl master"
  Dir.mktmpdir do |tmp|
    cp_r "_site/.", tmp
    Dir.chdir tmp
    system "git init"
    system "git add ."
    message = "Site updated at #{Time.now.utc}"
    system "git commit -m #{message.shellescape}"
    system "git remote add origin git@github.com:#{GITHUB_REPONAME}.git"
    system "git push origin master:gh-pages --force"
  end
end
