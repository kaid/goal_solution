module Oppia
  module Utils
    private

    def ValidationError(msg, &block)
      raise ValidationError.new(msg) if block.call
    end

    def attr_for(klass, collection)
      attr_name = klass.to_s.demodulize.underscore.pluralize

      ValidationError("Invalid #{self.class.to_s} #{attr_name}: #{collection.class.to_s}") do
        ![Array, Hash].include?(collection.class)
      end

      result = case collection
               when Array then collection.map {|i| klass.new(i)}
               when Hash  then Hash[collection.map {|k, v| [k, klass.new(v)]}]
               end

      self.instance_variable_set("@#{attr_name}", result)
    end
  end
end
