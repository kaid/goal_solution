class InvalidOperation < Exception
  module Helpers
    private

    def invalid_op(string, &invalid)
      raise InvalidOperation.new("#{self.class.to_s}#{string}") if invalid.call
    end
  end
end
