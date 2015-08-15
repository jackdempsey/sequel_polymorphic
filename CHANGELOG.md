# 0.2.2 (2015-08-07)

* **Fix**: *errors if model's or through model's class name is CamelCased*.

  I.e. `model.commentable` caused an error if `CamelCasedClassName.many_to_one :commentable, :polymorphic => true` has been used.
  I.e. `model.tags` caused an error if `Model.many_to_many :tags, :through => :camel_cased_through_class, :as => :taggable` has been used.

  See [#9](https://github.com/jackdempsey/sequel_polymorphic/issues/9)
  and [#11](https://github.com/jackdempsey/sequel_polymorphic/issues/11).

# 0.2.1 (2015-08-04)

* **Fix**: *many-to-one `#association` method and eager loader error*.

  See [#9](https://github.com/jackdempsey/sequel_polymorphic/issues/9).

# 0.2.0 (2015-06-10)

* **Breaking change**: *don't raise an exception if many-to-one association is absent*.

  Before: A `NameError` is raised by eager loader if association is absent.

  Now: `nil` is returned.

  See [#8](https://github.com/jackdempsey/sequel_polymorphic/issues/8).

# 0.1.1 (2015-06-09)

* **Fix**: *a `NameError` exception is raised if many-to-one association and Sequel >=4.15.0 are used*.

  See [#7](https://github.com/jackdempsey/sequel_polymorphic/issues/7).

* Code enhancements.

# 0.1.0 (2014-09-06)

Initial release.
