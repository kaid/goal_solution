class Goal
  module Insert
    def insert_between(goal)
      invalid = self.next != goal || goal.previous != self
      invalid_op("::add_between") {invalid}
      new_goal = self.class.new(:previous => self, :next => goal)
      self.next = new_goal
      goal.previous = new_goal
    end

    def remove
      self.next.previous = self.previous if self.next
      self.previous.next = self.next if self.previous
      self.class.all.delete_if {|goal| goal.id == self.id}
    end
  end
end
