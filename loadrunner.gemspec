lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'loadrunner/version'

Gem::Specification.new do |s|
  s.name        = 'loadrunner'
  s.version     = Loadrunner::VERSION
  s.summary     = 'GitHub Webhook Server and Simulator'
  s.description = 'Run your GitHub webhook server and Send simulated github events'
  s.authors     = ['Danny Ben Shitrit']
  s.email       = 'db@dannyben.com'
  s.files       = Dir['README.md', 'lib/**/*.*']
  s.executables = ['loadrunner']
  s.homepage    = 'https://github.com/DannyBen/loadrunner'
  s.license     = 'MIT'
  s.required_ruby_version = '>= 3.1'

  s.add_dependency 'colsole', '~> 1.0'
  s.add_dependency 'httparty', '~> 0.21'
  s.add_dependency 'puma', '~> 6.0'
  s.add_dependency 'sinatra', '>= 3.0', '< 5'
  s.add_dependency 'sinatra-contrib', '>= 3.0', '< 5'
  s.add_dependency 'super_docopt', '~> 0.2'

  # REMOVE ME
  s.add_dependency 'bigdecimal', '>= 0'  # to address ruby warning by multi_xml
  s.add_dependency 'csv', '>= 0'         # to address ruby warning by httparty

  s.metadata = {
    'bug_tracker_uri'       => 'https://github.com/DannyBen/loadrunner/issues',
    'changelog_uri'         => 'https://github.com/DannyBen/loadrunner/blob/master/CHANGELOG.md',
    'source_code_uri'       => 'https://github.com/DannyBen/loadrunner',
    'rubygems_mfa_required' => 'true',
  }
end
