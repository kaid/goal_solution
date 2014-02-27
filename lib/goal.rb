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

  def previous
    return @previous if @previous

    if @previous_id == Solution::HEAD
      @previous = @previous_id
    else
      @previous = Goal.find(@previous_id)
    end
  end

  def next
    return @next if @next

    if @next_id == Solution::TAIL
      @next = @next_id
    else
      @next = Goal.find(@next_id)
    end
  end
  
  def previous_id
    return @previous_id = @previous.id if @previous.is_a?(Goal)
    return @previous_id = @previous if @previous == Solution::HEAD
    @previous_id
  end

  def next_id
    return @next_id = @next.id if @next.is_a?(Goal)
    return @next_id = @next if @next == Solution::TAIL
    @next_id
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
    return rel.id if rel.is_a?(Goal)
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
