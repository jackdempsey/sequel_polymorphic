# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = 'sequel_polymorphic'
  s.version = '0.1.1'
  s.required_ruby_version = '>= 1.8.7'

  s.description = %q{A gem that provides Sequel::Models with polymorphic association capabilities}
  s.summary = %q{A gem that provides Sequel::Models with polymorphic association capabilities}
  s.authors = ['Jack Dempsey', 'Dave Myron']
  s.homepage = 'https://github.com/jackdempsey/sequel_polymorphic'
  s.license = 'MIT'
  s.email = ['jack.dempsey@gmail.com', 'therealdave.myron@gmail.com'}
  s.files = ['LICENSE', 'README.md', 'lib/sequel_polymorphic/sequel_polymorphic.rb', 'lib/sequel_polymorphic.rb']
  s.require_paths = ['lib']
  s.extra_rdoc_files = ['README.md', 'LICENSE']

  s.add_runtime_dependency 'sequel', '~> 4.0'

  s.add_development_dependency 'rspec', '~> 2.14.1'
  s.add_development_dependency 'sqlite3', '~> 1.3.10'
end
