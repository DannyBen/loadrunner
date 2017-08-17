lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'date'
require 'load_runner/version'

Gem::Specification.new do |s|
  s.name        = 'loadrunner'
  s.version     = LoadRunner::VERSION
  s.date        = Date.today.to_s
  s.summary     = "GitHub Webhook Server and Simulator"
  s.description = "Run your GitHub webhook server and Send simulated github events"
  s.authors     = ["Danny Ben Shitrit"]
  s.email       = 'db@dannyben.com'
  s.files       = Dir['README.md', 'lib/**/*.*']
  s.executables = ["loadrunner"]
  s.homepage    = 'https://github.com/DannyBen/loadrunner'
  s.license     = 'MIT'
  s.required_ruby_version = ">= 2.3.0"

  s.add_runtime_dependency 'httparty', '~> 0.14'
  s.add_runtime_dependency 'sinatra', '~> 2.0'
  s.add_runtime_dependency 'puma', '~> 3.9'
  s.add_runtime_dependency 'activesupport', '~> 5.1'
  s.add_runtime_dependency 'awesome_print', '~> 1.8'
  
  s.add_development_dependency 'runfile', '~> 0.10'
  s.add_development_dependency 'runfile-tasks', '~> 0.4'
  s.add_development_dependency 'rspec', '~> 3.4'
  s.add_development_dependency 'simplecov', '~> 0.14'
  s.add_development_dependency 'byebug', '~> 9.0'
  s.add_development_dependency 'sinatra-contrib', '~> 2.0'
  s.add_development_dependency 'rack-test', '~> 0.7'
  s.add_development_dependency 'yard', '~> 0.9'
end
