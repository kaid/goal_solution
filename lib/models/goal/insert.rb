class Goal
  class Insert
    attr_reader :insertion, :solution, :direction, :target

    def initialize(insertion, direction, target)
      @insertion = insertion
      @solution  = insertion.solution
      @direction = direction
      @target    = target
    end

    def pair
      rels = [:prev, :next]

      case direction.to_s
      when "before" then rels
      when "after"  then rels.reverse
      end
    end

    def run
      which1, which2 = pair

      insertion.send("#{which1}_id=",  target.send("#{which1}_id"))
      insertion.send("#{which2}_id=", target.id)
      insertion.save

      if target.is_a?(Goal)
        target.send("#{which1}_id=", insertion.id)
        target.save
      end

      if target.send("#{which1}").is_a?(Goal)
        target.send("#{which1}").send("#{which2}_id=", insertion.id)
        target.send("#{which1}").save
      end

      insertion
    end
  end
end
