
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "dad_jokes_are_funny/version"

Gem::Specification.new do |spec|
  spec.name          = "dad_jokes_are_funny"
  spec.version       = DadJokesAreFunny::VERSION
  spec.authors       = ["Dan Wanek"]
  spec.email         = ["dan.wanek@gmail.com"]

  spec.summary       = %q{Dad Jokes are Funny - Joke Generator}
  spec.description   = %q{A Joke Generator using Markov Chains}
  spec.homepage      = "https://bitbucket.org/zentourist/dad-jokes-are-funny"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rubocop"
end
