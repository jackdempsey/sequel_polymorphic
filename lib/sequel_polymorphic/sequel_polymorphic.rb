module Sequel
  module Plugins
    module Polymorphic
      # Apply the plugin to the model.
      def self.apply(model, options = {})
        raise "You must pass in an options hash!" if options.blank?
        plural_model = model.to_s.downcase.pluralize
        singular_model = model.to_s.downcase.singularize
        if as_variable = (options[:belongs_to] or options[:many_to_one])
          # defining the polymorphic model
          model.class_eval %{associate(:many_to_one, :#{as_variable}, :reciprocal=>:#{plural_model},
            :dataset=>(proc { klass = #{as_variable}_type.constantize; klass.filter(klass.primary_key=>#{as_variable}_id) }), 
            :eager_loader=>(proc do |key_hash, #{plural_model}, associations|
              id_map = {}
              #{plural_model}.each { |#{singular_model}| #{singular_model}.associations[:#{as_variable}] = nil; ((id_map[#{singular_model}.#{as_variable}_type] ||= {})[#{singular_model}.#{as_variable}_id] ||= []) << #{singular_model} }
              id_map.each do |klass_name, id_map|
                klass = klass_name.constantize
                klass.filter(klass.primary_key=>id_map.keys).all do |related_obj|
                  id_map[related_obj.pk].each { |#{singular_model}| #{singular_model}.associations[:#{as_variable}] = related_obj }
                end
              end
            end))

            private

            def _#{as_variable}=(#{as_variable})
              self[:#{as_variable}_id] = (#{as_variable}.pk if #{as_variable})
              self[:#{as_variable}_type] = (#{as_variable}.class.name if #{as_variable})
            end
            }
        elsif one_to_many_variable = (options[:one_to_many] or options[:has_many])
          raise "You must pass in an :as key-value pair!" unless as_variable = options[:as]
          singular_one_to_many_variable = one_to_many_variable.to_s.singularize
          model.class_eval %{
            associate(:one_to_many, :#{one_to_many_variable}, :key=>:#{as_variable}_id) do |ds|
              ds.filter(:#{as_variable}_type=>'#{model}')
            end

            private

            def _add_#{singular_one_to_many_variable}(#{singular_one_to_many_variable})
              #{singular_one_to_many_variable}.#{as_variable}_id = pk
              #{singular_one_to_many_variable}.#{as_variable}_type = '#{model}'
              #{singular_one_to_many_variable}.save
            end
            def _remove_#{singular_one_to_many_variable}(#{singular_one_to_many_variable})
              #{singular_one_to_many_variable}.#{as_variable}_id = nil
              #{singular_one_to_many_variable}.#{as_variable}_type = nil
              #{singular_one_to_many_variable}.save
            end
            def _remove_all_#{one_to_many_variable}
              #{singular_one_to_many_variable.capitalize}.filter(:#{as_variable}_id=>pk, :#{as_variable}_type=>'Post').update(:#{as_variable}_id=>nil, :#{as_variable}_type=>nil)
            end
          }
        end
      end

      module InstanceMethods

      end

      module ClassMethods
      end # ClassMethods
    end # Polymorphic
  end # Plugins
end # Sequel


