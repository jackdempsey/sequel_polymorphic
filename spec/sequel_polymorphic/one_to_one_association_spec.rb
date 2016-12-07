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
        @question.add_post(@post)
        assert_equal @post.postable, @question
        assert_equal @question.post, @post
      end
    end

    describe "#association=" do
      it "should set association" do
        @post.postable = @question
        @post.save
        @question.refresh
        assert_equal @question.post, @post
      end
    end

    # TODO: add tests for standard #one_to_one association fallback

    # TODO: add #has_one alias test
  end # "one-to-one association"
end # Sequel::Plugins::Polymorphic
