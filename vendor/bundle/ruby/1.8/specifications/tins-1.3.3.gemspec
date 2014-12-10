# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{tins}
  s.version = "1.3.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Florian Frank"]
  s.date = %q{2014-09-18}
  s.description = %q{All the stuff that isn't good/big enough for a real library.}
  s.email = %q{flori@ping.de}
  s.files = ["tests/annotate_test.rb", "tests/ask_and_send_test.rb", "tests/attempt_test.rb", "tests/bijection_test.rb", "tests/blank_full_test.rb", "tests/case_predicate_test.rb", "tests/concern_test.rb", "tests/count_by_test.rb", "tests/date_dummy_test.rb", "tests/date_time_dummy_test.rb", "tests/deep_const_get_test.rb", "tests/deep_dup_test.rb", "tests/delegate_test.rb", "tests/dslkit_test.rb", "tests/dynamic_scope_test.rb", "tests/extract_last_argument_options_test.rb", "tests/file_binary_test.rb", "tests/find_test.rb", "tests/from_module_test.rb", "tests/generator_test.rb", "tests/go_test.rb", "tests/hash_symbolize_keys_recursive_test.rb", "tests/hash_union_test.rb", "tests/if_predicate_test.rb", "tests/limited_test.rb", "tests/lines_file_test.rb", "tests/memoize_test.rb", "tests/method_description_test.rb", "tests/minimize_test.rb", "tests/module_group_test.rb", "tests/named_set_test.rb", "tests/named_test.rb", "tests/null_test.rb", "tests/p_test.rb", "tests/partial_application_test.rb", "tests/proc_compose_test.rb", "tests/proc_prelude_test.rb", "tests/range_plus_test.rb", "tests/require_maybe_test.rb", "tests/responding_test.rb", "tests/rotate_test.rb", "tests/scope_test.rb", "tests/secure_write_test.rb", "tests/sexy_singleton_test.rb", "tests/shuffle_test.rb", "tests/string_byte_order_mark_test.rb", "tests/string_camelize_test.rb", "tests/string_underscore_test.rb", "tests/string_version_test.rb", "tests/subhash_test.rb", "tests/test_helper.rb", "tests/time_dummy_test.rb", "tests/time_freezer_test.rb", "tests/to_test.rb", "tests/token_test.rb", "tests/uniq_by_test.rb"]
  s.homepage = %q{http://flori.github.com/tins}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Useful stuff.}
  s.test_files = ["tests/annotate_test.rb", "tests/ask_and_send_test.rb", "tests/attempt_test.rb", "tests/bijection_test.rb", "tests/blank_full_test.rb", "tests/case_predicate_test.rb", "tests/concern_test.rb", "tests/count_by_test.rb", "tests/date_dummy_test.rb", "tests/date_time_dummy_test.rb", "tests/deep_const_get_test.rb", "tests/deep_dup_test.rb", "tests/delegate_test.rb", "tests/dslkit_test.rb", "tests/dynamic_scope_test.rb", "tests/extract_last_argument_options_test.rb", "tests/file_binary_test.rb", "tests/find_test.rb", "tests/from_module_test.rb", "tests/generator_test.rb", "tests/go_test.rb", "tests/hash_symbolize_keys_recursive_test.rb", "tests/hash_union_test.rb", "tests/if_predicate_test.rb", "tests/limited_test.rb", "tests/lines_file_test.rb", "tests/memoize_test.rb", "tests/method_description_test.rb", "tests/minimize_test.rb", "tests/module_group_test.rb", "tests/named_set_test.rb", "tests/named_test.rb", "tests/null_test.rb", "tests/p_test.rb", "tests/partial_application_test.rb", "tests/proc_compose_test.rb", "tests/proc_prelude_test.rb", "tests/range_plus_test.rb", "tests/require_maybe_test.rb", "tests/responding_test.rb", "tests/rotate_test.rb", "tests/scope_test.rb", "tests/secure_write_test.rb", "tests/sexy_singleton_test.rb", "tests/shuffle_test.rb", "tests/string_byte_order_mark_test.rb", "tests/string_camelize_test.rb", "tests/string_underscore_test.rb", "tests/string_version_test.rb", "tests/subhash_test.rb", "tests/test_helper.rb", "tests/time_dummy_test.rb", "tests/time_freezer_test.rb", "tests/to_test.rb", "tests/token_test.rb", "tests/uniq_by_test.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<gem_hadar>, ["~> 1.0.0"])
      s.add_development_dependency(%q<test-unit>, ["~> 2.5"])
    else
      s.add_dependency(%q<gem_hadar>, ["~> 1.0.0"])
      s.add_dependency(%q<test-unit>, ["~> 2.5"])
    end
  else
    s.add_dependency(%q<gem_hadar>, ["~> 1.0.0"])
    s.add_dependency(%q<test-unit>, ["~> 2.5"])
  end
end
