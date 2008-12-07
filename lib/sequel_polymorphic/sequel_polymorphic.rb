module Sequel
  module Plugins
    module Polymorphic
      # Apply the plugin to the model.
      def self.apply(model, options = {})
      end

      module InstanceMethods

      end

      module ClassMethods
        def many_to_one(*args, &block)
          able, options = *args
          options ||= {}
          if options[:polymorphic]
            model = self.class.to_s.downcase
            plural_model = model.pluralize
            singular_model = model.singularize
            self.class_eval %{
              associate(:many_to_one, :#{able}, :reciprocal=>:#{plural_model},
                 :dataset=>(proc { klass = #{able}_type.constantize; klass.filter(klass.primary_key=>#{able}_id) }), 
                 :eager_loader=>(proc do |key_hash, #{plural_model}, associations|
                   id_map = {}
                   #{plural_model}.each do |#{singular_model}| 
                     #{singular_model}.associations[:#{able}] = nil; 
                     ((id_map[#{singular_model}.#{able}_type] ||= {})[#{singular_model}.#{able}_id] ||= []) << #{singular_model}
                   end
                   id_map.each do |klass_name, id_map|
                     klass = klass_name.constantize
                     klass.filter(klass.primary_key=>id_map.keys).all do |related_obj|
                       id_map[related_obj.pk].each { |#{singular_model}| #{singular_model}.associations[:#{able}] = related_obj }
                     end
                   end
                 end)
              )
             
              private
             
              def _#{able}=(#{able})
                self[:#{able}_id] = (#{able}.pk if #{able})
                self[:#{able}_type] = (#{able}.class.name if #{able})
              end
            }
          else
            associate(:many_to_one, *args, &block)
          end
        end
        
        alias :belongs_to :many_to_one

        def one_to_many(*args, &block)
          one_to_many_variable, options = *args
          many_class = one_to_many_variable.to_s.singularize
          if able = options[:as]
             method_definitions = %{
               associate(:one_to_many, :#{one_to_many_variable}, :key=>:#{able}_id) do |ds|
                 ds.filter(:#{able}_type=>'#{self}')
               end
           
               private
           
               def _add_#{many_class}(#{many_class})
                 #{many_class}.#{able}_id = pk
                 #{many_class}.#{able}_type = '#{self}'
                 #{many_class}.save
               end
               def _remove_#{many_class}(#{many_class})
                 #{many_class}.#{able}_id = nil
                 #{many_class}.#{able}_type = nil
                 #{many_class}.save
               end
               def _remove_all_#{one_to_many_variable}
                 #{many_class.capitalize}.filter(:#{able}_id=>pk, :#{able}_type=>'#{self}').update(:#{able}_id=>nil, :#{able}_type=>nil)
               end
             }
             self.class_eval method_definitions
          else
            associate(:one_to_many, *args, &block)
          end
        end
        
        alias :has_many :one_to_many
        
      end # ClassMethods
    end # Polymorphic
  end # Plugins
end # Sequel


