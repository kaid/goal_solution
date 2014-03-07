module Oppia
  class ParamSpec
    attr_reader :obj_type

    def initialize(hash)
      @obj_type = hash["obj_type"]
    end
  end
end
