module Oppia
  class ParamChange
    attr_accessor :generator_id, :customization_args, :name

    def initialize(hash)
      self.name               = hash["name"]
      self.generator_id       = hash["generator_id"]
      self.customization_args = hash["customization_args"]
    end
  end
end
