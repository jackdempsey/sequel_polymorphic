$TESTING=true
$:.push File.join(File.dirname(__FILE__), '..', 'lib')

require 'rubygems'
require 'sequel'
require 'simplecov'
SimpleCov.start do
  add_filter 'spec'
  command_name 'Mintest'
end
require 'minitest/autorun'

require File.dirname(__FILE__) + '/../lib/sequel_polymorphic'
require File.dirname(__FILE__) + '/sequel-setup'


