module Oppia
  class Content
    include Utils

    attr_accessor :type, :value

    def initialize(hash)
      self.type  = hash["type"]
      self.value = hash["value"]
      self.validate
    end

    def validate
      ValidationError("Invalid content type: #{self.type}") do
        self.type != "text"
      end

      ValidationError("Invalid content value: #{self.value}") do
        !self.value.is_a?(String)
      end
    end
  end
end
