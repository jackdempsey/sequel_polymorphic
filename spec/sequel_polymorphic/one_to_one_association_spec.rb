require File.dirname(__FILE__) + '/../spec_helper'

describe Sequel::Plugins::Polymorphic do
  describe "one-to-one association" do
    before do
      Post.dataset.delete
      Question.dataset.delete

      @post = Post.create(:name => 'test post')
      @question = Question.create
    end

    describe "#association" do
      it "should return associated object" do
        @question.post = @post
        assert_equal @post.postable, @question
        assert_equal @question.post, @post
      end

      # TODO: add tests of merging options
    end

    describe "#association=" do
      it "should set association" do
        @post.postable = @question
        @post.save
        @question.refresh
        assert_equal @question.post, @post
      end
    end

    describe "#where=" do
      it "should return items with a specific model using find" do
        @post.postable = @question
        @post.save
        assert_equal Post.find(postable: @question), @post
      end

      it "should return items with a specific model using where" do
        @post.postable = @question
        @post.save
        assert_equal Post.where(postable: @question).all, [@post]
      end
    end

    # TODO: add tests for standard #one_to_one association fallback

    # TODO: add #has_one alias test
  end # "one-to-one association"
end # Sequel::Plugins::Polymorphic
