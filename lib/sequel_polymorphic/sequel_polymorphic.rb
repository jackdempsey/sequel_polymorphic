module Sequel
  module Plugins
    module Polymorphic
      # Apply the plugin to the model.
      def self.apply(model, options = {})
      end

      module InstanceMethods

      end

      module ClassMethods

        # Example: Comment.many_to_one :commentable, polymorphic: true
        def many_to_one(*args, &block)
          able, options = *args
          options ||= {}

          if options[:polymorphic]
            model = self.to_s.downcase          # comment
            plural_model = pluralize(model)     # comments

            associate(:many_to_one, able,
              :reciprocal => plural_model.to_sym,
              :setter => (proc do |able_instance|
                self[:"#{able}_id"]   = (able_instance.pk if able_instance)
                self[:"#{able}_type"] = (able_instance.class.name if able_instance)
              end),
              :dataset => (proc do
                klass = constantize(send(:"#{able}_type"))
                klass.where(klass.primary_key => send(:"#{able}_id"))
              end),
              :eager_loader => (proc do |eo|
                id_map = {}
                eo[:rows].each do |model|
                  model.associations[able] = nil
                  ((id_map[model.send(:"#{able}_type")] ||= {})[model.send(:"#{able}_id")] ||= []) << model
                end
                id_map.each do |klass_name, id_map|
                  klass = constantize(klass_name)
                  klass.where(klass.primary_key=>id_map.keys).all do |related_obj|
                    id_map[related_obj.pk].each do |model|
                      model.associations[able] = related_obj
                    end
                  end
                end
              end)
            )

          else
            associate(:many_to_one, *args, &block)
          end
        end

        alias :belongs_to :many_to_one


        # Creates a one-to-many relationship. NB: Removing/clearing nullifies the *able fields in the related objects
        # Example: Post.one_to_many :comments, as: :commentable
        def one_to_many(*args, &block)
          collection_name, options = *args
          options ||= {}

          if able = options[:as]
            able_id           = :"#{able}_id"
            able_type         = :"#{able}_type"
            many_dataset_name = :"#{collection_name}_dataset"

            associate(:one_to_many, collection_name,
              :key        => able_id,
              :reciprocal => able,
              :conditions => {able_type => self.to_s},
              :adder      => proc { |many_of_instance| many_of_instance.update(able_id => pk, able_type => self.class.to_s) },
              :remover    => proc { |many_of_instance| many_of_instance.update(able_id => nil, able_type => nil) },
              :clearer    => proc { send(many_dataset_name).update(able_id => nil, able_type => nil) }
            )

          else
            associate(:one_to_many, *args, &block)
          end
        end

        alias :has_many :one_to_many


        # Creates a many-to-many relationship. NB: Removing/clearing the collection deletes the instances in the through relationship (as opposed to nullifying the *able fields as in the one-to-many)
        # Example: Post.many_to_many :tags, :through => :taggings, :as => :taggable
        def many_to_many(*args, &block)
          collection_name, options = *args
          options ||= {}

          if through = (options[:through] || options[:join_table]) and able = options[:as]
            able_id                = :"#{able}_id"
            able_type              = :"#{able}_type"
            collection_singular    = singularize(collection_name.to_s).to_sym # => tag
            collection_singular_id = :"#{collection_singular}_id"
            through_klass          = constantize(singularize(through.to_s).capitalize) # => Tagging

            associate(:many_to_many, collection_name,
              :left_key   => able_id,
              :join_table => through,
              :conditions => {able_type => self.to_s},
              :adder      => proc { |many_of_instance| through_klass.create(collection_singular_id => many_of_instance.pk, able_id => pk, able_type => self.class.to_s) },
              :remover    => proc { |many_of_instance| through_klass.where(collection_singular_id => many_of_instance.pk, able_id => pk, able_type => self.class.to_s).delete },
              :clearer    => proc { through_klass.where(able_id => pk, able_type => self.class.to_s).delete }
            )

          else
            associate(:many_to_many, *args, &block)
          end
        end
      end # ClassMethods
    end # Polymorphic
  end # Plugins
end # Sequel


