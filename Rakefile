require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "postrank-api"
    gemspec.summary = "PostRank API Wrapper"
    gemspec.description = gemspec.summary
    gemspec.email = "ilya@igvita.com"
    gemspec.homepage = "http://github.com/postrank/postrank-api"
    gemspec.authors = ["Ilya Grigorik"]
    gemspec.add_dependency('eventmachine', '>= 0.12.9')
    gemspec.required_ruby_version = ">= 1.9.1"
    gemspec.rubyforge_project = "em-http"
    gemspec.rubyforge_project = "em-synchrony"
  end

  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end
