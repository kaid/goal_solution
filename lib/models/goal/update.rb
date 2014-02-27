class Goal
  module Update
    def previous=(goal)
      return self.update(:previous => goal) if !goal.is_a?(Goal)
      goal.update(:next => self.update(:previous => goal))
    end

    def next=(goal)
      return self.update(:next => goal) if !goal.is_a?(Goal)
      goal.update(:previous => self.update(:next => goal))
    end

    def update(attrs = {})
      attrs.each do |key, value|
        instance_variable_set(:"@#{key}", value)
      end
      self
    end
  end
end
