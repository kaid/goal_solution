class Goal
  class InvalidOperation < Exception
    module Helpers
      private

      def invalid_op(string, &invalid)
        raise InvalidOperation.new("#{self.class.to_s}#{string}") if invalid.call
      end
    end
  end

  class Solution
    HEAD = "::START"
    TAIL = "::END"

    include InvalidOperation::Helpers

    attr_reader :head, :tail
    attr_accessor :master

    def self.attach_to(goal)
      solution = self.new
      solution.master = goal
      self.all << solution
      solution
    end

    def self.all
      @all ||= []
    end

    def add_head(goal = nil)
      invalid_op("#add_head") {head}
      @head = goal || Goal.new
      head.previous = HEAD if head.next.nil?
      head
    end

    def add_tail(goal = nil)
      invalid_op("#add_tail") {tail}
      @tail = goal || Goal.new
      tail.next = TAIL if tail.next.nil?
      tail
    end

    def head_branch
      Branch.new(head: self.head)
    end

    def tail_branch
      Branch.new(tail: self.tail)
    end

    def list
      head_list = head_branch.list
      tail_list = tail_branch.list
      return head_list if head_list == tail_list
      head_list + tail_list
    end

    def xml_with(builder)
      builder.solution {
        self.list.each do |goal|
          goal.xml_with(builder)
        end
      }
    end

    def init_with(xml)
      xml.children.each do |goal_el|
        goal = Goal.new.init_with(goal_el)
        self.add_head(goal) if goal.instance_variable_get("@previous_id") == HEAD
        self.add_tail(goal) if goal.instance_variable_get("@next_id") == TAIL
      end
      self
    end

    module GoalMethods
      def add_solution
        Solution.attach_to(self)
      end
      
      def solutions
        Solution.all.select do |solution|
          solution.master == self
        end
      end
    end
  end

  class Branch
    attr_accessor :head, :tail

    def initialize(head: nil, tail: nil)
      @head = head
      @tail = tail
    end

    def list
      return list_from(:head) if head
      return list_from(:tail) if tail
      []
    end

    def ==(branch)
      self.list == branch.list
    end

    private

    def traverse(what)
      current = self.send(what)

      dir = :next     if what == :head
      dir = :previous if what == :tail

      while current.send(dir).is_a?(Goal)
        yield current
        current = current.send(dir)
      end
    end

    def list_from(what)
      result  = []
      method = :<<      if what == :head
      method = :unshift if what == :tail
      traverse(what) {|current| result.send method, current}
      result
    end
  end
end
