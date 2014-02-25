class Goal
  class Solution < Array
    def solution_xml(builder)
      builder.solution {
        self.each do |goal|
          goal.goal_xml(builder)
        end
      }
    end
  end

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
      goal.update(:section => self)
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
