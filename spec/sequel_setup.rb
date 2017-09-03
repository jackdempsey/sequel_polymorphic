DB = Sequel.sqlite
Sequel::Model.plugin :polymorphic

DB.create_table!(:assets) do
  primary_key :id
  String  :name
  Integer :attachable_id
  String  :attachable_type
end

DB.create_table!(:taggings) do
  Integer :taggable_id
  String  :taggable_type
  Integer :tag_id
end

DB.create_table!(:posts) do
  primary_key :id
  String :name
  Integer :postable_id
  String :postable_type
end

DB.create_table!(:notes) do
  primary_key :id
  String :name
end

DB.create_table!(:tags) do
  primary_key :id
  String :name
end

DB.create_table!(:questions) do
primary_key :id
end

class Asset < Sequel::Model
  many_to_one :attachable, :polymorphic => true
end


module Nested
  class Asset < Sequel::Model(:assets)
    many_to_one :attachable, :polymorphic => true
  end
end


class Tagging < Sequel::Model
  many_to_one :taggable, :polymorphic => true
  many_to_one :tag
end


class Post < Sequel::Model
  one_to_many :assets, :as => :attachable
  one_to_many :nested_assets, :as => :attachable, :class => Nested::Asset
  many_to_many :tags, :through => :taggings, :as => :taggable
  many_to_one :postable, :polymorphic => true
end


class Note < Sequel::Model
  one_to_many :assets, :as => :attachable
end


class Tag < Sequel::Model

end


class Question < Sequel::Model
  one_to_one :post, :as => :postable
end
