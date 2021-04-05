lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'date'
require 'loadrunner/version'

Gem::Specification.new do |s|
  s.name        = 'loadrunner'
  s.version     = Loadrunner::VERSION
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

  s.add_runtime_dependency 'super_docopt', '~> 0.1'
  s.add_runtime_dependency 'httparty', '~> 0.14'
  s.add_runtime_dependency 'sinatra', '~> 2.0'
  s.add_runtime_dependency 'sinatra-contrib', '~> 2.0'
  s.add_runtime_dependency 'puma', '~> 5.2'
  s.add_runtime_dependency 'colsole', '~> 0.6'
end
