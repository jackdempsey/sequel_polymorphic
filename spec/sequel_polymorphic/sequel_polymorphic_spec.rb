require File.dirname(__FILE__) + '/../spec_helper'

describe Sequel::Plugins::Polymorphic do
  before do
    Post.dataset.delete
    Asset.dataset.delete
    Tagging.dataset.delete
    Tag.dataset.delete
  end

  it "should create an add_asset method which associates an Asset with a Post" do
    post = Post.create(:name => 'test post')
    asset = Asset.create(:name => "post's asset")
    post.add_asset(asset)
    asset.save
    asset.refresh
    asset.attachable_id.should == post.pk
    asset.attachable_type.should == post.class.to_s
    asset.attachable.should == post
  end

  it "should handle assignment via many_to_one relationship" do
    post = Post.create(:name => 'test post')
    asset = Asset.create(:name => "post's asset")
    asset.attachable = post
    asset.attachable_id.should == post.pk
    asset.attachable_type.should == post.class.to_s
  end

  it "should return the list of related objects" do
    post = Post.create(:name => 'test post')
    asset1 = Asset.create(:name => "post's first asset")
    asset2 = Asset.create(:name => "post's second asset")
    post.add_asset(asset1)
    post.add_asset(asset2)
    post.assets.should == [asset1,asset2]
  end

  describe "one_to_many with many associated objects" do
    before do
      @post = Post.create(:name => 'test post')
      @asset1 = Asset.create(:name => "post's first asset")
      @asset2 = Asset.create(:name => "post's second asset")
      @post.add_asset(@asset1)
      @post.add_asset(@asset2)
    end

    it "should remove a single association" do
      @post.remove_asset(@asset1)
      @asset1.refresh
      @asset1.attachable_id.should be_nil
      @asset1.attachable_type.should be_nil
    end

    it "should remove all associations" do
      @post.remove_all_assets
      [@asset1, @asset2].each do |asset|
        asset.refresh
        asset.attachable_id.should be_nil
        asset.attachable_type.should be_nil
      end
    end
  end

  describe "many_to_many association" do
    before do
      @post = Post.create(:name => 'test post')
      @tag  = Tag.create(:name => 'test tag')
    end

    it "should allow adding from the left side" do
      @post.add_tag @tag
    end

    describe "with items in the collection" do
      before do
        @tag2 = Tag.create(:name => 'another tag')
        @post.add_tag @tag
        @post.add_tag @tag2
      end

      it "should allow retrieving the collection" do
        @post.tags.should == [@tag, @tag2]
      end

      it "should allow removing an instance from the collection" do
        Tagging.count.should == 2
        @post.remove_tag @tag
        @post.tags.should == [@tag2]
        Tagging.count.should == 1
      end

      it "should allow removing all instances from a collection" do
        Tagging.count.should == 2
        @post.remove_all_tags
        @post.tags.should == []
        Tagging.count.should == 0
      end
    end
  end
end
