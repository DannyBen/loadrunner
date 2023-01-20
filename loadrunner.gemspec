lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'loadrunner/version'

Gem::Specification.new do |s|
  s.name        = 'loadrunner'
  s.version     = Loadrunner::VERSION
  s.summary     = "GitHub Webhook Server and Simulator"
  s.description = "Run your GitHub webhook server and Send simulated github events"
  s.authors     = ["Danny Ben Shitrit"]
  s.email       = 'db@dannyben.com'
  s.files       = Dir['README.md', 'lib/**/*.*']
  s.executables = ["loadrunner"]
  s.homepage    = 'https://github.com/DannyBen/loadrunner'
  s.license     = 'MIT'
  s.required_ruby_version = ">= 2.7.0"

  s.add_runtime_dependency 'colsole', '~> 0.8', '>= 0.8.1'
  s.add_runtime_dependency 'httparty', '~> 0.21'
  s.add_runtime_dependency 'puma', '~> 6.0'
  s.add_runtime_dependency 'sinatra', '~> 3.0'
  s.add_runtime_dependency 'sinatra-contrib', '~> 3.0'
  s.add_runtime_dependency 'super_docopt', '~> 0.1'
end
