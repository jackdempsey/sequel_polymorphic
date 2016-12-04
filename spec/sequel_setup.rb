DB = Sequel.sqlite
Sequel::Model.plugin :schema
Sequel::Model.plugin :polymorphic

class Asset < Sequel::Model
  set_schema do
    primary_key :id
    String  :name
    Integer :attachable_id
    String  :attachable_type
  end

  many_to_one :attachable, :polymorphic => true
end


module Nested
  class Asset < Sequel::Model
    set_schema do
      primary_key :id
      String  :name
      Integer :attachable_id
      String  :attachable_type
    end

    many_to_one :attachable, :polymorphic => true
  end
end


class Tagging < Sequel::Model
  set_schema do
    Integer :taggable_id
    String  :taggable_type
    Integer :tag_id
  end

  many_to_one :taggable, :polymorphic => true
  many_to_one :tag
end


class Post < Sequel::Model
  set_schema do
    primary_key :id
    String :name
    Integer :postable_id
    String :postable_type
  end

  one_to_many :assets, :as => :attachable
  one_to_many :nested_assets, :as => :attachable, class: Nested::Asset
  many_to_many :tags, :through => :taggings, :as => :taggable
  many_to_one :postable, :polymorphic => true
end


class Note < Sequel::Model
  set_schema do
    primary_key :id
    String :name
  end

  one_to_many :assets, :as => :attachable
end


class Tag < Sequel::Model
  set_schema do
    primary_key :id
    String :name
  end
end


class Question < Sequel::Model
  set_schema do
    primary_key :id
  end

  one_to_one :post, :as => :postable
end



[Asset, Nested::Asset, Post, Note, Question, Tag, Tagging].each {|klass| klass.create_table!}
