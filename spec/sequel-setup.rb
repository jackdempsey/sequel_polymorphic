Sequel::Model.plugin(SequelPolymorphic)
Sequel::Model.plugin(:schema)

DB = Sequel.sqlite
 
class Asset < Sequel::Model
  set_schema do
    primary_key :id
    varchar :name
    integer :attachable_id
    varchar :attachable_type
  end
  
  is :polymorphic
  belongs_to :attachable, :polymorphic => true
  
end

class Post < Sequel::Model
  set_schema do
    primary_key :id
    varchar :name
  end

  is :polymorphic
  has_many :assets, :as => :attachable
end


class Note < Sequel::Model
  set_schema do
    primary_key :id
    varchar :name
  end

  is :polymorphic
  has_many :assets, :as => :attachable
end

[Asset, Post, Note].each {|klass| klass.create_table!}
