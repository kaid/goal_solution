require "./config/env"
require "./lib/models/goal/insert"
require "./lib/models/goal/serialization"
require "./lib/models/invalid_operation"
require "./lib/models/solution"

class Goal
  include Mongoid::Document
  include Mongoid::Timestamps
  include Serialization
  include InvalidOperation::Helpers

  field :name,        type: String
  field :desc,        type: String
  field :init_desc,   type: String
  field :finish_desc, type: String  
  field :prev_id
  field :next_id

  has_many   :solutions
  belongs_to :solution

  serialize :id, :name, :desc, :init_desc,
            :finish_desc, :prev_id, :next_id

  before_destroy do |goal|
    binding.pry
    prv, nxt = goal.prev, goal.next
    nxt.prev = prv if nxt.is_a?(Goal)
    prv.next = nxt if prv.is_a?(Goal)
  end

  def prev
    return if self.prev_id.nil? || self.solution.nil?
    return self.solution.begin if self.prev_id == self.solution.begin.id
    Goal.find(self.prev_id)
  end

  def next
    return if self.next_id.nil? || self.solution.nil?
    return self.solution.end if self.next_id == self.solution.end.id
    Goal.find(self.next_id)
  end

  def prev=(goal)
    set_rel(:prev, goal)
  end

  def next=(goal)
    set_rel(:next, goal)
  end

  def insert=(insrt)
    Insert.new(self, insrt[:direction], insrt[:target]).run
  end

  def create_solution
    self.solutions.create
  end

  def opposite(which)
    return :next if which == :prev
    :prev if which == :next
  end

  def to_xml(options = {})
    attrs = attributes.map do |key, value|
      next if value.nil?;key
    end.compact - %w(_id created_at updated_at solution_id) + [:id]

    options.merge!({
      skip_instruct: true,
      dasherize: false,
      skip_types: true,
      include: [:solutions],
      only: attrs,
      methods: [:id]
    })

    super(options)
  end

  private

  def set_rel(which, goal)
    awhich = opposite(which)

    goal_id = goal && goal.id
    self.send("#{which}_id=", goal_id)
    if goal.is_a?(Goal)
      goal.send("#{awhich}_id=", self.id);goal.save if goal.persisted?
    end;self.save if self.persisted?

    goal
  end
end
