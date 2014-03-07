module Oppia
  class RuleSpec
    include Utils

    attr_accessor :definition, :dest, :feedback, :param_changes

    def initialize(hash)
      self.definition    = hash["definition"]
      self.dest          = hash["dest"]
      self.feedback      = hash["feedback"]
      self.param_changes = hash["param_changes"]
    end

    def param_changes=(list)
      attr_for(ParamChange, list)
    end

    def dest=(str)
      return @dest = End if "END" == str
      @dest = Exploration.states[str]
    end
  end
end
