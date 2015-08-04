require File.dirname(__FILE__) + '/../spec_helper'

describe Sequel::Plugins::Polymorphic do
  describe "many-to-one association" do
    before do
      Post.dataset.delete
      Asset.dataset.delete
      @post = Post.create(:name => 'test post')
      @asset1 = Asset.create(:name => "post's first asset")
      @asset2 = Asset.create(:name => "post's second asset")
    end

    describe "#association" do
      it "should return associated object" do
        @post.add_asset(@asset1)
        @asset1.attachable.should == @post
      end
    end

    describe "#association=" do
      it "should set association" do
        @asset1.attachable = @post
        @asset1.save
        @post.refresh
        @post.assets.should == [@asset1]
        @asset2.attachable = @post
        @asset2.save
        @post.refresh
        @post.assets.should == [@asset1, @asset2]
      end
    end

    # TODO: add eager loader tests

    # TODO: add tests for standard #many_to_one association fallback

    # TODO: add #belongs_to alias test
  end
end


