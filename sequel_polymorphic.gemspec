# -*- encoding: utf-8 -*-

require File.expand_path('../lib/sequel_polymorphic/version', __FILE__)

Gem::Specification.new do |s|
  s.name = 'sequel_polymorphic'
  s.version = Sequel::Plugins::Polymorphic::VERSION
  s.required_ruby_version = '>= 1.8.7'

  s.description = %q{A gem that provides Sequel::Models with polymorphic association capabilities}
  s.summary = %q{A gem that provides Sequel::Models with polymorphic association capabilities}
  s.authors = ['Jack Dempsey', 'Dave Myron', 'Alexander Kurakin']
  s.homepage = 'https://github.com/jackdempsey/sequel_polymorphic'
  s.license = 'MIT'
  s.email = ['jack.dempsey@gmail.com', 'therealdave.myron@gmail.com', 'kuraga333@mail.ru']
  s.files = ['README.md', 'LICENSE', 'CHANGELOG.md', 'lib/sequel_polymorphic.rb',
    'lib/sequel_polymorphic/version.rb', 'lib/sequel_polymorphic/sequel_polymorphic.rb']
  s.require_paths = ['lib']
  s.extra_rdoc_files = ['README.md', 'LICENSE', 'CHANGELOG.md']

  s.add_runtime_dependency 'sequel', '~> 4.0'

  s.add_development_dependency 'minitest', '~> 5.8'
  s.add_development_dependency 'minitest-hooks', '~> 1.2'
  s.add_development_dependency 'sqlite3', '~> 1.3.10'
end
