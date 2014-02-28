require "./lib/models/solution/begin_end"
require "./lib/models/solution/serialization"

class Solution
  include Mongoid::Document
  include Mongoid::Timestamps
  include Serialization
  include InvalidOperation::Helpers

  has_many   :goals
  belongs_to :goal

  def create_goal(name: nil, direction: nil, target: nil)
    valid_dir       = ["before", "after"].include?(direction.to_s)
    invalid_target1 = ["before", "::BEGIN"] == [direction.to_s, target]
    invalid_target2 = ["after", "::END"]    == [direction.to_s, target]

    invalid_op("#create_goal") {
      !(name && valid_dir && target) ||
      invalid_target1 ||
      invalid_target2
    }

    what  = case target
            when self.begin.id then self.begin
            when self.end.id   then self.end
            else Goal.find(target)
            end

    self.goals.create(name: name, insert: {direction: direction, target: what})
  end

  def begin
    @begin ||= Begin.new(self)
  end

  def end
    @end ||= End.new(self)
  end
end
