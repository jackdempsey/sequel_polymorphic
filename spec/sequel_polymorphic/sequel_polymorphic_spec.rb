require File.dirname(__FILE__) + '/../spec_helper'

describe Sequel::Plugins::Taggable do
  before do
    @tagged_model = TaggedModel.new
  end
  
  it "should add a .has_tags method to models which include DataMapper::Resource" do
    TaggedModel.should respond_to(:has_tags)
    # AnotherTaggedModel.should respond_to(:has_tags)
    # DefaultTaggedModel.should respond_to(:has_tags)
    # UntaggedModel.should respond_to(:has_tags)
  end

  it "should add a .has_tags_on method to models which include DataMapper::Resource" do
    TaggedModel.should respond_to(:has_tags_on)
  #   AnotherTaggedModel.should respond_to(:has_tags_on)
  #   DefaultTaggedModel.should respond_to(:has_tags_on)
  #   UntaggedModel.should respond_to(:has_tags_on)
  end

  describe ".has_tags_on" do
    it "should accept an array of context names" do
      class HasTagsOnTestModel < Sequel::Model
        is :taggable
      end
      lambda{HasTagsOnTestModel.has_tags_on(:should, 'not', :raise)}.should_not raise_error(ArgumentError)
    end

    it "should create taggable functionality for each of the context names passed" do
      class TestModel < Sequel::Model
        is :taggable
        has_tags_on :pets, 'skills', :tags
      end
      TestModel.should be_taggable
      a = TestModel.new
      a.should be_taggable
      a.should respond_to(:pet_list)
      a.should respond_to(:skill_list)
      a.should respond_to(:tag_list)
      a.should respond_to(:pet_list=)
      a.should respond_to(:skill_list=)
      a.should respond_to(:tag_list=)
    end
  end
  
  describe ".has_tags" do
    it "should raise an error message if someone uses has_tags with an argument list" do
      lambda do 
        class TagsOnly < Sequel::Model
          is :taggable
          has_tags :pets, :skills
        end
      end.should raise_error(RuntimeError)
    end
  end
end
