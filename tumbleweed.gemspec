# coding: utf-8
require File.expand_path('../lib/tumbleweed/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Elia Schito']
  gem.email         = ['elia@schito.me']
  gem.description   = %q{Mechanized tumblr theme uploads}
  gem.summary       = %q{Mechanized tumblr theme uploads}
  gem.homepage      = ''

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = 'tumbleweed'
  gem.require_paths = ['lib']
  gem.version       = Tumbleweed::VERSION
  gem.license       = 'MIT'
  
  gem.add_development_dependency 'rake'
  gem.add_runtime_dependency 'mechanize', '~> 2.1'
  gem.add_runtime_dependency 'json', '~> 1.6.3'
end
