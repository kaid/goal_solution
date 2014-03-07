module Oppia
  class Handler
    include Utils

    attr_accessor :rule_specs, :name

    def initialize(hash)
      self.rule_specs = hash["rule_specs"]
      self.name       = hash["name"]
    end

    def rule_specs=(list)
      attr_for(RuleSpec, list)
    end
  end
end
