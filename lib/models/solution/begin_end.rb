class Solution
  class Begin
    def initialize(solution)
      @solution = solution
    end

    def id
      "::BEGIN"
    end

    def next
      @solution.goals.where(:prev_id => self.id).first
    end

    def next_id
      self.next && self.next.id
    end
  end

  class End
    def initialize(solution)
      @solution = solution
    end

    def id
      "::END"
    end

    def prev
      @solution.goals.where(:next_id => self.id).first
    end

    def prev_id
      self.prev && self.prev.id
    end
  end
end
