require File.dirname(__FILE__) + '/../spec_helper'

describe Sequel::Plugins::Polymorphic do
  describe "one-to-many association" do
    before do
      Post.dataset.delete
      Asset.dataset.delete
      @post = Post.create(:name => 'test post')
      @asset1 = Asset.create(:name => "post's first asset")
      @asset2 = Asset.create(:name => "post's second asset")
    end

    describe "#associations" do
      it "should return the list of associated objects" do
        @post.add_asset(@asset1)
        @post.assets.should == [@asset1]
        @post.add_asset(@asset2)
        @post.assets.should == [@asset1, @asset2]
      end
    end

    describe "#add_association" do
      it "should associate an object" do
        @post.add_asset(@asset1)
        @post.assets.should == [@asset1]
        @post.add_asset(@asset2)
        @post.assets.should == [@asset1, @asset2]
      end

      it "should associate object with itself" do
        @post.add_asset(@asset1)
        @asset1.refresh
        @asset1.attachable.should == @post
      end
    end

    describe "#remove_association" do
      it "should remove a single association" do
        @post.add_asset(@asset1)
        @post.add_asset(@asset2)
        @post.remove_asset(@asset1)
        @post.assets.should == [@asset2]
      end

      it "should remove itself from associated object" do
        @post.add_asset(@asset1)
        @post.add_asset(@asset2)
        @post.remove_asset(@asset1)
        @asset1.refresh
        @asset1.attachable.should be_nil
      end
    end

    describe "#remove_all_associations" do
      it "should remove all associations" do
        @post.add_asset(@asset1)
        @post.add_asset(@asset2)
        @post.remove_all_assets
        @post.assets.should be_empty
      end

      it "should remove itself from all associations" do
        @post.add_asset(@asset1)
        @post.add_asset(@asset2)
        @post.remove_all_assets
        [@asset1, @asset2].each do |asset|
          asset.refresh
          asset.attachable.should be_nil
        end
      end
    end

    # TODO: add tests for standard #many_to_many association fallback

    # TODO: add #has_many alias test
  end
end


