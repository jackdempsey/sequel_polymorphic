# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{sequel_polymorphic}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jack Dempsey"]
  s.autorequire = %q{sequel_polymorphic}
  s.date = %q{2008-12-08}
  s.description = %q{A gem that provides Sequel::Models with polymorphic association capabilities}
  s.email = %q{jack.dempsey@gmail.com}
  s.extra_rdoc_files = ["README", "LICENSE", "TODO"]
  s.files = ["LICENSE", "README", "Rakefile", "TODO", "lib/sequel_polymorphic", "lib/sequel_polymorphic/sequel_polymorphic.rb", "lib/sequel_polymorphic.rb", "spec/sequel-setup.rb", "spec/sequel_polymorphic", "spec/sequel_polymorphic/sequel_polymorphic_spec.rb", "spec/spec.opts", "spec/spec_helper.rb"]
  s.homepage = %q{http://jackndempsey.blogspot.com}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{A gem that provides Sequel::Models with polymorphic association capabilities}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
