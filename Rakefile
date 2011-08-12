task :default => :test


### TESTING ###
desc 'Run unit tests'
task 'test' do |t|
  sh 'ruby test/test_all.rb'
end


### PACKAGING ###
begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "maneki"
    gemspec.summary = "A simple file-based model for your Ruby projects"
    gemspec.description = "Maneki loads and parses any relevant text files in a given directory"
    gemspec.email = "nathan@nathanhoad.net"
    gemspec.homepage = "http://github.com/nathanhoad/maneki"
    gemspec.authors = ["Nathan Hoad"]
    gemspec.files = `git ls-files`.split("\n").sort.reject{ |file| file =~ /^\./ }
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install jeweler"
end


### DOCUMENTATION ###
require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  if File.exist? 'VERSION'
    version = File.read('VERSION')
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "Maneki #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end