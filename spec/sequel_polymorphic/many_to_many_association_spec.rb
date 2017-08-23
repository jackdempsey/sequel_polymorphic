require File.dirname(__FILE__) + '/../spec_helper'

describe Sequel::Plugins::Polymorphic do
  describe "many-to-many association" do
    before do
      Post.dataset.delete
      Tagging.dataset.delete
      Tag.dataset.delete

      @post = Post.create(:name => 'test post')
      @tag1 = Tag.create(:name => "post's first tag")
      @tag2 = Tag.create(:name => "post's second tag")
    end

    describe "#associations" do
      it "should return the list of associated objects" do
        @post.add_tag(@tag1)
        assert_equal @post.tags, [@tag1]

        @post.add_tag(@tag2)
        assert_equal @post.tags, [@tag1, @tag2]
      end

      # TODO: add tests of merging options
    end

    describe "#add_association" do
      it "should associate an object" do
        @post.add_tag(@tag1)
        assert_equal @post.tags, [@tag1]

        @post.add_tag(@tag2)
        assert_equal @post.tags, [@tag1, @tag2]
      end
    end

    describe "#remove_association" do
      it "should remove a single association" do
        @post.add_tag(@tag1)
        @post.add_tag(@tag2)
        @post.remove_tag(@tag1)
        assert_equal @post.tags, [@tag2]
      end
    end

    describe "#remove_all_associations" do
      it "should remove all associations" do
        @post.add_tag(@tag1)
        @post.add_tag(@tag2)
        @post.remove_all_tags
        assert_empty @post.tags
      end
    end

    describe "#where" do
      it "should return items with a specific model using find" do
        @tag3 = Tag.create(:name => "Test2")
        @tagging3 = Tagging.create(:taggable => @post, :tag => @tag3)

        assert_equal Tagging.find(taggable: @post, tag: @tag3), @tagging3
      end

      it "should return items with a specific model using where" do
        @tag3 = Tag.create(:name => "Test2")
        @tagging3 = Tagging.create(:taggable => @post, :tag => @tag3)

        assert_equal Tagging.where(taggable: @post, tag: @tag3).first.tag, @tag3
      end

      it "should return items with a specific model using where and non-polymorphic" do
        @tagging = Tagging.first

        assert_equal Tagging.where(tag: @tag1).first, @tagging
      end

      it "should return items with a specific model using find and non-polymorphic" do
        @tagging = Tagging.first
        assert_equal Tagging.find(tag: @tag1), @tagging
      end

      # TODO: add tests for standard #where fallback
    end

    # TODO: add tests for standard #many_to_many association fallback
  end # "many-to-many association"
end # Sequel::Plugins::Polymorphic
