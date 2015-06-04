# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{sequel_polymorphic}
  s.version = "0.1.0"

  s.authors = ["Jack Dempsey", "Dave Myron"]
  s.description = %q{A gem that provides Sequel::Models with polymorphic association capabilities}
  s.email = %q{therealdave.myron@gmail.com}
  s.extra_rdoc_files = ["README.md", "LICENSE"]
  s.files = ["LICENSE", "README.md", "lib/sequel_polymorphic/sequel_polymorphic.rb", "lib/sequel_polymorphic.rb"]
  s.homepage = %q{https://github.com/jackdempsey/sequel_polymorphic}
  s.require_paths = ["lib"]
  s.summary = %q{A gem that provides Sequel::Models with polymorphic association capabilities}

  s.add_runtime_dependency 'sequel', '~> 4.0'
end
