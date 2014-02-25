class Goal
  class Section < Array
    attr_reader :master

    def self.make_for(master)
      self.new.attach(master)
    end

    def create(params = {})
      goal = Goal.new(params)
      self << goal
      goal
    end

    def <<(goal)
      goal.update(:under => self.master, :section => self)
      super(goal)
    end

    def attach(goal)
      @master = goal
      self
    end
  end

  class Start < Section; end
  class End < Section; end
  class InvalidOperation < Exception; end
end
