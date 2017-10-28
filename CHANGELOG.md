# 0.4.0 (2017-10-25)

* **Enhancements**: *migrate to new Sequel's plugins tree schema.*

  This step is required for Sequel 5 compatibility.

  See [#27](https://github.com/jackdempsey/sequel_polymorphic/pull/27).
  Thanks to [@jnylen](https://github.com/jnylen).

* **Enhancements**: *get rid of `schema` Sequel's plugin*.

  This step is required for Sequel 5 compatibility.

  See [#23](https://github.com/jackdempsey/sequel_polymorphic/pull/23).
  Thanks to [@jnylen](https://github.com/jnylen).

* **Fix**: *`one_to_one` association tries to add an adder, remover and clearer methods*.

  It's not correct and generates an error in Sequel 5.

  See [#26](https://github.com/jackdempsey/sequel_polymorphic/pull/26).
  Thanks to [@jnylen](https://github.com/jnylen).

* **Feature**: *make this gem compatible with Sequel 5.x.x versions*.

  See previous changes in this version.

# 0.3.1 (2017-01-05)

* **Fix**: *blocks are not passed to `associate`*.

  See [#21](https://github.com/jackdempsey/sequel_polymorphic/pull/21).
  Thanks to [@shioyama](https://github.com/shioyama).

# 0.3.0 (2016-12-12)

* **Feature**: *add one-to-one polymorphic associations support*.

* **Feature**: *relax Sequel version dependency to any 4.x version*.

* **Feature**: *all unrecognised options are passed to underlying methods now*.

  For instance you can set an association class with `one_to_many :nested_assets, :as => :attachable, :class => Nested::Asset`.

* **Enhancements**: many code improvements:

  * Use [Minitest](https://github.com/seattlerb/minitest) instead of [RSpec](http://rspec.info/) for unit testing.
  * Add code coverage (via [SimpleCov](https://github.com/colszowka/simplecov)).
  * Add [Rake](https://github.com/ruby/rake) as a dependency (though it has been already used).
  * Code improvements.
  * Tests improvements.

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
