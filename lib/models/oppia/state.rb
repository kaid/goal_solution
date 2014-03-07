module Oppia
  class State
    include Utils

    attr_accessor :contents, :param_changes, :widget

    def initialize(hash)
      self.contents = hash["content"]
      self.widget   = Widget.new(hash["widget"])
      self.param_changes = hash["param_changes"]
    end

    def param_changes=(list)
      attr_for(ParamChange, list)
    end

    def contents=(list)
      attr_for(Content, list)
    end
  end
end
