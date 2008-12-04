require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Tag do
  before(:each) do
    @tag = Tag.new
  end

  it "should have id and name properties" do
    @tag.should respond_to(:id)
    @tag.should respond_to(:name)
  end

  it "should have many Taggings" do
    Tag.associations.should include(:taggings)
  end

  it "should validate the presence of name" do
    @tag.should_not be_valid
    @tag.name = "Meme"
    @tag.should be_valid
  end
end
