$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "array_logic/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "array_logic"
  s.version     = ArrayLogic::VERSION
  s.authors     = ["Rob Nichols"]
  s.email       = ["rob@undervale.co.uk"]
  s.homepage    = "https://github.com/reggieb/array_logic"
  s.summary     = "Matches arrays of objects against logical rules."
  s.description = "Allow a user to define a set of rules, and then test to see if an array of object match those rules."

  s.files = Dir["lib/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]
end