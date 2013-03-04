#Sequel Polymorphic

A simple plugin for Sequel::Model's that lets you easily create polymorphic associations.

##ActiveRecord Style

```ruby
class Asset < ActiveRecord::Base
  belongs_to :attachable, :polymorphic => true
end

class Post < ActiveRecord::Base
  has_many :assets, :as => :attachable
end

class Note < ActiveRecord::Base
  has_many :assets, :as => :attachable
end

@asset.attachable = @post
@asset.attachable = @note
```

## Sequel (without plugin)

In Sequel you would do the following:

```ruby
class Asset < Sequel::Model
  many_to_one :attachable, :reciprocal=>:assets, \
    :dataset=>(proc do
      klass = attachable_type.constantize
      klass.filter(klass.primary_key=>attachable_id)
    end), \
    :eager_loader=>(proc do |key_hash, assets, associations|
      id_map = {}
      assets.each do |asset|
        asset.associations[:attachable] = nil
        ((id_map[asset.attachable_type] ||= {})[asset.attachable_id] ||= []) << asset
      end
      id_map.each do |klass_name, id_map|
        klass = klass_name.constantize
        klass.filter(klass.primary_key=>id_map.keys).all do |attach|
          id_map[attach.pk].each do |asset|
            asset.associations[:attachable] = attach
          end
        end
      end
    end)

  private

  def _attachable=(attachable)
    self[:attachable_id] = (attachable.pk if attachable)
    self[:attachable_type] = (attachable.class.name if attachable)
  end
end

class Post < Sequel::Model
  one_to_many :assets, :key=>:attachable_id do |ds|
    ds.filter(:attachable_type=>'Post')
  end

  private

  def _add_asset(asset)
    asset.attachable_id = pk
    asset.attachable_type = 'Post'
    asset.save
  end
  def _remove_asset(asset)
    asset.attachable_id = nil
    asset.attachable_type = nil
    asset.save
  end
  def _remove_all_assets
    Asset.filter(:attachable_id=>pk, :attachable_type=>'Post')\
      .update(:attachable_id=>nil, :attachable_type=>nil)
  end
end

class Note < Sequel::Model
  one_to_many :assets, :key=>:attachable_id do |ds|
    ds.filter(:attachable_type=>'Note')
  end

  private

  def _add_asset(asset)
    asset.attachable_id = pk
    asset.attachable_type = 'Note'
    asset.save
  end
  def _remove_asset(asset)
    asset.attachable_id = nil
    asset.attachable_type = nil
    asset.save
  end
  def _remove_all_assets
    Asset.filter(:attachable_id=>pk, :attachable_type=>'Note')\
      .update(:attachable_id=>nil, :attachable_type=>nil)
  end
end

@asset.attachable = @post
@asset.attachable = @note
```

Thats quite a bit of code. With sequel_polymorphic you can now do:

## Polymorphic

```ruby
class Note < Sequel::Model
  is :polymorphic
  one_to_many :assets, :as => :attachable
end

class Asset < Sequel::Model
  is :polymorphic
  many_to_one :attachable, :polymorphic => true
end

```