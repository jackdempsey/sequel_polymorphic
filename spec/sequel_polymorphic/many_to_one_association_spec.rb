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
        assert_equal @asset1.attachable, @post
      end

      # TODO: add tests of merging options
    end

    describe "#association=" do
      it "should set association" do
        @asset1.attachable = @post
        @asset1.save
        @post.refresh
        assert_equal @post.assets, [@asset1]

        @asset2.attachable = @post
        @asset2.save
        @post.refresh
        assert_equal @post.assets, [@asset1, @asset2]
      end
    end

    describe "#where" do
      it "should return items with a specific model using find" do
        @asset1.attachable = @post
        @asset1.save
        @post.refresh

        assert_equal Asset.find(attachable: @post), @asset1
      end

      it "should return items with a specific model using where" do
        @asset1.attachable = @post
        @asset1.save
        @post.refresh

        assert_equal Asset.where(attachable: @post).first, @asset1
      end

      it "should return items with a specific model using where and non-polymorphic" do
        @tag = Tag.create(:name => "Test")
        @tagging = Tagging.create(:taggable => @post, :tag => @tag)

        assert_equal Tagging.where(tag: @tag).first, @tagging
      end

      it "should return items with a specific model using find and non-polymorphic" do
        @tag = Tag.create(:name => "Test")
        @tagging = Tagging.create(:taggable => @post, :tag => @tag)

        assert_equal Tagging.find(tag: @tag), @tagging
      end

      # TODO: add tests for standard #where fallback
    end

    # TODO: add eager loader tests

    # TODO: add tests for standard #many_to_one association fallback

    # TODO: add #belongs_to alias test
  end # "many-to-one association"
end # Sequel::Plugins::Polymorphic
