class Goal
  module Link
    def half_linked?
      self.next     && !self.previous ||
      self.previous && !self.next
    end

    def isolated?
      !(self.previous || self.next)
    end

    def link(goal)
      invalid1 = !self.half_linked? && !self.half_linked?
      invalid2 = self.isolated? || goal.isolated?
      invalid_op("#link") {invalid1 || invalid2}
      self.next = goal if !goal.previous.is_a?(Goal)
      self.previous = goal if !goal.next.is_a?(Goal)
    end

    def unlink(goal)
      invalid_op("#unlink") {!link_with?(goal)}
      self.next, goal.previous = nil if self.next == goal && goal.previous == self
      goal.next, self.previous = nil if goal.next == self && self.previous == goal
    end

    private

    def link_with?(goal)
      self.next == goal && goal.previous == self ||
      self.previous == goal && goal.next == self
    end
  end
end
