$TESTING=true
$:.push File.join(File.dirname(__FILE__), '..', 'lib')

require 'rubygems'
require 'sequel'
require 'minitest/autorun'

require File.dirname(__FILE__) + '/../lib/sequel_polymorphic'
require File.dirname(__FILE__) + '/sequel-setup'


