require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Tagging do
  before(:each) do
    @tagging = Tagging.new
  end

  it "should have properties: id, tag_id, taggable_id, taggable_type, tagger_id, tagger_type, and tag_context" do
    @tagging.should respond_to(:id)
    @tagging.should respond_to(:tag_id)
    @tagging.should respond_to(:taggable_id)
    @tagging.should respond_to(:taggable_type)
    @tagging.should respond_to(:tag_context)
  end

  it "should validate the presence of tag_id, taggable_id, taggable_type and tag_context" do
    @tagging.should_not be_valid
    @tagging.tag_id = 1
    @tagging.should_not be_valid
    @tagging.taggable_id = 1
    @tagging.should_not be_valid
    @tagging.taggable_type = "TaggedModel"
    @tagging.should_not be_valid
    @tagging.tag_context = "skills"
    @tagging.should be_valid
  end

  it "should many_to_one :tag" do
    Tagging.associations.should include(:tag)
    Tagging.association_reflection(:tag)[:class_name].should == "Tag"
  end

  it "should have a method Tagging#taggable which returns the associated taggable instance" do
    @tagging.should respond_to(:taggable)
    @tagging.taggable.should_not be
    @tagging.taggable_id = 11111
    @tagging.taggable_type = "TaggedModel"
    TaggedModel.should_receive(:get!).with(11111)
    @tagging.taggable
  end
end
