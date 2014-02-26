require "bundler"
Bundler.setup(:default)
require "pry"
require "./lib/utils"
require "./lib/serialization"
require "./lib/add"
require "./lib/insert"
require "./lib/update"
require "./lib/link"

class Goal
  include Update
  include Add
  include Insert
  include Link
  include Serialization
  include InvalidOperation::Helpers
  include Solution::GoalMethods

  attr_reader :id, :name, :desc
  attr_reader :init_desc, :finish_desc
  attr_reader :previous, :next
  attr_reader :previous_id, :next_id

  serialize :id, :name, :desc, :init_desc,
            :finish_desc, :previous_id, :next_id

  def initialize(attrs = {})
    self.update(attrs)
    @id = randstr if @id.nil?
    self.class.all << self
  end

  def previous_id
    rel_id(:previous)
  end

  def next_id
    rel_id(:next)
  end

  class << self
    def all
      @all ||= []
    end

    def current
      @current
    end

    def current=(goal)
      @current = goal
    end

    def find(id)
      self.all.detect {|goal| goal.id == id}
    end
  end

  private

  def rel_id(type)
    rel = instance_variable_get(:"@#{type}")
    return rel.id if rel
  end

  def randstr(length=8)
    base = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    size = base.size
    re = '' << base[rand(size-10)]
    (length - 1).times {
      re << base[rand(size)]
    }
    re
  end
end
