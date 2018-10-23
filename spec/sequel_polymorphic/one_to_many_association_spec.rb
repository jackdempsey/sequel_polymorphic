require File.dirname(__FILE__) + '/../spec_helper'

describe Sequel::Plugins::Polymorphic do
  describe "one-to-many association" do
    before do
      Post.dataset.delete
      Asset.dataset.delete

      @post = Post.create(:name => 'test post')
      @asset1 = Asset.create(:name => "post's first asset")
      @asset2 = Asset.create(:name => "post's second asset")

      @nested_asset = Nested::Asset.create(:name => "nested assset")
    end

    describe "#associations" do
      it "should return the list of associated objects" do
        @post.add_asset(@asset1)
        assert_equal @post.assets, [@asset1]

        @post.add_asset(@asset2)
        assert_equal @post.assets, [@asset1, @asset2]
      end

      describe "association with class name" do
        it "should return the list of associated objects" do
          @post.add_nested_asset(@nested_asset)
          assert_equal @post.nested_assets, [@nested_asset]
        end
      end
    end

    describe "#add_association" do
      it "should associate an object" do
        @post.add_asset(@asset1)
        assert_equal @post.assets, [@asset1]

        @post.add_asset(@asset2)
        assert_equal @post.assets, [@asset1, @asset2]
      end

      it "should associate object with itself" do
        @post.add_asset(@asset1)
        @asset1.refresh
        assert_equal @asset1.attachable, @post
      end
    end

    describe "#remove_association" do
      it "should remove a single association" do
        @post.add_asset(@asset1)
        @post.add_asset(@asset2)
        @post.remove_asset(@asset1)
        assert_equal @post.assets, [@asset2]
      end

      it "should remove itself from associated object" do
        @post.add_asset(@asset1)
        @post.add_asset(@asset2)
        @post.remove_asset(@asset1)
        @asset1.refresh
        assert_nil @asset1.attachable
      end
    end

    describe "#remove_all_associations" do
      it "should remove all associations" do
        @post.add_asset(@asset1)
        @post.add_asset(@asset2)
        @post.remove_all_assets
        assert_empty @post.assets
      end

      it "should remove itself from all associations" do
        @post.add_asset(@asset1)
        @post.add_asset(@asset2)
        @post.remove_all_assets
        [@asset1, @asset2].each do |asset|
          asset.refresh
          assert_nil asset.attachable
        end
      end
    end

    describe "#where" do
      it "should return items with a specific model using find" do
        @post.add_asset(@asset1)
        assert_equal Asset.find(attachable: @post), @asset1
      end

      it "should return items with a specific model using where" do
        @post.add_asset(@asset1)
        @post.add_asset(@asset2)
        assert_equal Asset.where(attachable: @post).all, [@asset1, @asset2]
      end

      it "should return items with a specific model using find (nested)" do
        @post.add_nested_asset(@nested_asset)
        assert_equal Nested::Asset.find(attachable: @post), @nested_asset
      end

      it "should return items with a specific model using where (nested)" do
        @post.add_nested_asset(@nested_asset)
        assert_equal Nested::Asset.where(attachable: @post).all, [@nested_asset]
      end

      # TODO: add tests for standard #where fallback
    end

    # TODO: add tests for standard #many_to_many association fallback

    # TODO: add #has_many alias test
  end # "one-to-many association"
end # Sequel::Plugins::Polymorphic
