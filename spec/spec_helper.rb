$TESTING=true
$:.push File.join(File.dirname(__FILE__), '..', 'lib')

require 'rubygems'
require 'spec'
require 'sequel'

require File.dirname(__FILE__) + '/sequel-setup'
require File.dirname(__FILE__) + '/../lib/sequel_polymorphic'



