# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{amatch}
  s.version = "0.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Florian Frank"]
  s.date = %q{2014-03-27}
  s.default_executable = %q{agrep.rb}
  s.description = %q{Amatch is a library for approximate string matching and searching in strings.
Several algorithms can be used to do this, and it's also possible to compute a
similarity metric number between 0.0 and 1.0 for two given strings.
}
  s.email = %q{flori@ping.de}
  s.executables = ["agrep.rb"]
  s.extensions = ["ext/extconf.rb"]
  s.files = ["tests/test_hamming.rb", "tests/test_jaro.rb", "tests/test_jaro_winkler.rb", "tests/test_levenshtein.rb", "tests/test_longest_subsequence.rb", "tests/test_longest_substring.rb", "tests/test_pair_distance.rb", "tests/test_sellers.rb", "bin/agrep.rb", "ext/extconf.rb"]
  s.homepage = %q{http://github.com/flori/amatch}
  s.require_paths = ["lib", "ext"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Approximate String Matching library}
  s.test_files = ["tests/test_hamming.rb", "tests/test_jaro.rb", "tests/test_jaro_winkler.rb", "tests/test_levenshtein.rb", "tests/test_longest_subsequence.rb", "tests/test_longest_substring.rb", "tests/test_pair_distance.rb", "tests/test_sellers.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<gem_hadar>, ["~> 1.0.0"])
      s.add_development_dependency(%q<test-unit>, ["~> 2.3"])
      s.add_development_dependency(%q<utils>, [">= 0"])
      s.add_development_dependency(%q<rake>, ["< 11.0", "~> 10"])
      s.add_runtime_dependency(%q<tins>, ["~> 1.0"])
    else
      s.add_dependency(%q<gem_hadar>, ["~> 1.0.0"])
      s.add_dependency(%q<test-unit>, ["~> 2.3"])
      s.add_dependency(%q<utils>, [">= 0"])
      s.add_dependency(%q<rake>, ["< 11.0", "~> 10"])
      s.add_dependency(%q<tins>, ["~> 1.0"])
    end
  else
    s.add_dependency(%q<gem_hadar>, ["~> 1.0.0"])
    s.add_dependency(%q<test-unit>, ["~> 2.3"])
    s.add_dependency(%q<utils>, [">= 0"])
    s.add_dependency(%q<rake>, ["< 11.0", "~> 10"])
    s.add_dependency(%q<tins>, ["~> 1.0"])
  end
end
