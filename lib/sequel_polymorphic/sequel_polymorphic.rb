module Sequel
  module Plugins
    module Polymorphic
      # Apply the plugin to the model.
      def self.apply(model, options = {})
        if as_variable = (options[:belongs_to] or options[:many_to_one])
          # defining the polymorphic model
          model.class_eval %{associate(:many_to_one, #{as_variable}, :reciprocal=>:assets, 
            :dataset=>(proc { klass = attachable_type.constantize; klass.filter(klass.primary_key=>attachable_id) }), 
            :eager_loader=>(proc do |key_hash, assets, associations|
              id_map = {}
              assets.each { |asset| asset.associations[:attachable] = nil; ((id_map[asset.attachable_type] ||= {})[asset.attachable_id] ||= []) << asset }
              id_map.each do |klass_name, id_map|
                klass = klass_name.constantize
                klass.filter(klass.primary_key=>id_map.keys).all do |attach|
                  id_map[attach.pk].each { |asset| asset.associations[:attachable] = attach }
                end
              end
            end))}
        end
      end

      module InstanceMethods

      end

      module ClassMethods
      end # ClassMethods
    end # Polymorphic
  end # Plugins
end # Sequel

# class Asset < Sequel::Model
#   is :polymorphic, :belongs_to => :attachable
# end
# 
# class Post < Sequel::Model
#   is :polymorphic, :has_many => :assets, :as => :attachable
# end
# 
# class Note < Sequel::Model
#   is :polymorphic, :has_many => :assets, :as => :attachable
# end

