require 'sequel/extensions/blank'
require 'sequel/extensions/inflector'

module Sequel
  module Plugins
    module Polymorphic

      # Apply the plugin to the model.
      def self.apply(model_class, *arguments, &block)
      end

      def configure(model_class, *arguments, &block)
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
          many_of_class, options = *args
          options ||= {}
          many_class = many_of_class.to_s.singularize
          if able = options[:as]
            associate(:one_to_many, many_of_class, :key=>"#{able}_id".to_sym) do |ds|
              ds.filter("#{able}_type".to_sym => self.class.to_s)
            end

             method_definitions = %{
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
               def _remove_all_#{many_of_class}
                 #{many_class.capitalize}.filter(:#{able}_id=>pk, :#{able}_type=>'#{self}').update(:#{able}_id=>nil, :#{able}_type=>nil)
               end
             }
             self.class_eval method_definitions
          else
            associate(:one_to_many, *args, &block)
          end
        end
        
        alias :has_many :one_to_many
        
        #example:   many_to_many :tags, :through => :taggings, :as => :taggable
        def many_to_many(*args, &block)
          many_to_class, options = *args # => :tags, :through => :taggings, :as => :taggable
          many_class = many_to_class.to_s.singularize # => tag
          options ||= {}
          if through = (options[:through] or options[:join_table]) and able = options[:as]
            through_klass = through.to_s.singularize.capitalize # => Tagging
            # self in the block passed to associate is an instance of the class, hence the self.class call
            associate(:many_to_many, many_to_class,
                      :left_key => "#{able}_id".to_sym,
                      :join_table => through) { |ds| ds.filter("#{able}_type".to_sym => self.class.to_s) }

            method_string = %{
              private

              def _add_#{many_class}(#{many_class})
                #{through_klass}.create(:#{many_class}_id => #{many_class}.pk, :#{able}_id => pk, :#{able}_type => '#{self}')
              end

              def _remove_#{many_class}(#{many_class})
                #{through_klass}.filter(:#{many_class}_id => #{many_class}.pk, :#{able}_id => pk, :#{able}_type => '#{self}').delete
              end

              def _remove_all_#{many_to_class}
                #{through_klass}.filter(:#{able}_id=>pk, :#{able}_type=>'#{self}').delete
              end
            }
            self.class_eval method_string
          else
            associate(:many_to_many, *args, &block)
          end
        end
      end # ClassMethods
    end # Polymorphic
  end # Plugins
end # Sequel

