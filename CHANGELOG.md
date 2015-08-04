# 0.2.1 (2015-08-04)

* Fix for many-to-one `left#association` method and eager loader.

  See [#9](https://github.com/jackdempsey/sequel_polymorphic/issues/9)
  and [#10](https://github.com/jackdempsey/sequel_polymorphic/issues/10).

# 0.2.0 (2015-06-10)

* *Many-to-one associations breaking change*.

  Before: A `NameError` is raised by eager loader if association is absent.

  Now: `nil` is returned.

  See [#8](https://github.com/jackdempsey/sequel_polymorphic/issues/8).

# 0.1.1 (2015-06-09)

* *Many-to-one associations fix*.

  A `NameError` is raised if Sequel >=4.15.0 is used.

  See [#7](https://github.com/jackdempsey/sequel_polymorphic/issues/7).

* Code enhancements.

# 0.1.0 (2014-09-06)

Initial release.
