class Goal
  class Section < Array
    attr_reader :goal

    def self.make_for(goal)
      self.new.attach(goal)
    end

    def create(params = {})
      node = Goal.new(params.merge(:section => self))
      self << node
      node
    end

    def <<(node)
      super(node)
    end

    def attach(goal)
      @goal = goal
      self
    end
  end

  class Start < Section; end
  class End < Section; end
  class InvalidOperation < Exception; end
end
