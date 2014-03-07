module Oppia
  class Widget
    include Utils

    attr_accessor :customization_args, :handlers, :sticky

    def initialize(hash)
      self.customization_args = hash["customization_args"]
      self.handlers = hash["handlers"]
    end

    def handlers=(list)
      attr_for(Handler, list)
    end
  end
end
