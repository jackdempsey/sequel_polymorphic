# Sequel Polymorphic

A simple plugin for Sequel::Model's that lets you easily create polymorphic associations.

## Usage

### Models

```ruby
Sequel::Model.plugin(:polymorphic)

class Note < Sequel::Model
  has_many :assets, :as => :attachable
end

class Post < Sequel::Model
  has_many :assets, :as => :attachable
end

class Asset < Sequel::Model
  belongs_to :attachable, :polymorphic => true
end
```
### Schema

Include the polymorphic columns in your DB schema:

```ruby
Sequel.migration do
  change do
    create_table :assets do
      # ...
      Integer :attachable_id
      String :attachable_type
      # ...
      index [:attachable_id, :attachable_type]
    end
  end
end
```

## Similar to ActiveRecord Style

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

## Sequel (without the polymorphic plugin)

Check the [Advanced Assoocations](http://sequel.rubyforge.org/rdoc/files/doc/advanced_associations_rdoc.html) section of the [Sequel](http://sequel.rubyforge.org) docs (search "Polymorphic Associations")