module Oppia
  class Exploration
    include Utils

    attr_accessor :init_state_name, :states, :param_specs, :param_changes

    def self.from_yaml(path)
      self.new(YAML.load_file(path))
    end

    def self.states=(states)
      @states = states
    end

    def self.states
      @states || {}
    end

    def initialize(hash)
      self.init_state_name = hash["init_state_name"]
      self.states          = hash["states"]
      self.param_specs     = hash["param_specs"]
      self.param_changes   = hash["param_changes"]
      self.class.states    = self.states
    end

    def states=(hash)
      attr_for(State, hash)
    end

    def param_specs=(hash)
      attr_for(ParamSpec, hash)
    end

    def param_changes=(list)
      attr_for(ParamChange, list)
    end
  end
end
