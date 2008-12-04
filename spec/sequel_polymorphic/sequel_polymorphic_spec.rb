require File.dirname(__FILE__) + '/../spec_helper'

# Models we have: Post(name), Note(name), Asset(name)
describe Sequel::Plugins::Polymorphic do
  it "should raise an error if you call :has_many without providing an :as" do
    lambda do
      class Blowup < Sequel::Model
        is :polymorphic, :has_many => :items
      end
    end.should raise_error
  end

  it "should raise an error if you call 'is :polymorphic' without any args" do
    lambda do
      class Blowup < Sequel::Model
        is :polymorphic
      end
    end.should raise_error
  end
end
