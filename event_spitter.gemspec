# -*- encoding: utf-8 -*-
require File.expand_path('../lib/event_spitter/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["'Mike Breen'"]
  gem.email         = ["hardbap@gmail.com"]
  gem.description   = %q{An EventEmitter library for Ruby}
  gem.summary       = %q{}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "event_spitter"
  gem.require_paths = ["lib"]
  gem.version       = EventSpitter::VERSION
end
