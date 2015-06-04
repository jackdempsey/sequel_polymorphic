# Sequel Polymorphic

A simple plugin for [Sequel](http://sequel.jeremyevans.net) that lets you easily create polymorphic associations.

Version 4.x is required.

## Usage examples

### Models

```ruby
Sequel::Model.plugin(:polymorphic)

class Asset < Sequel::Model
  many_to_one :attachable, :polymorphic => true
end

class Note < Sequel::Model
  one_to_many :assets, :as => :attachable
end

class Post < Sequel::Model
  one_to_many :assets, :as => :attachable
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

### More usage examples

See [specs](https://github.com/jackdempsey/sequel_polymorphic/tree/master/spec).
