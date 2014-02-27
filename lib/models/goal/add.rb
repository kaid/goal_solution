class Goal
  module Add
    def add_before
      invalid_op("#add_before") {self.previous}
      self.previous = self.class.new(:next => self)
    end

    def add_after
      invalid_op("#add_after") {self.next}
      self.next = self.class.new(:previous => self)
    end
  end
end
