require "bundler"
Bundler.setup(:default)
require "./lib/utils"
require "./lib/serialization"

class Goal
  include Serialization

  attr_reader   :id, :start, :end
  attr_reader   :name, :desc
  attr_reader   :init_desc, :finish_desc
  attr_accessor :previous, :next
  attr_reader   :section, :from, :to

  def initialize(attrs = {})
    self.update(attrs)
    @start = Start.make_for(self)
    @end   = End.make_for(self)
    @id    = randstr
    self.class.all << self if self.isolated?
  end

  def self.all
    @all ||= []
  end

  def self.find(id)
    self.all.detect {|goal| goal.id == id}
  end

  def self.toplevel_goals
    self.all.select {|goal| goal.isolated?}
  end

  def update(attrs = {})
    attrs.each do |key, value|
      instance_variable_set(:"@#{key}", value)
    end
    self
  end

  def from
    section_for_kind(Start)
  end

  def to
    section_for_kind(End)
  end

  def previous=(goal)
    return self.update(:previous => nil) if goal.nil?
    goal.update(:next => self.update(:previous => goal))
  end

  def next=(goal)
    return self.update(:next => nil) if goal.nil?
    goal.update(:previous => self.update(:next => goal))
  end

  def remove
    invalid = self.to || self.from || !self.previous || !self.next
    raise InvalidOperation.new("#remove") if invalid
    self.next.previous = self.previous
    self.previous.next = self.next
  end

  def half_linked?
    self.from     && !self.to       ||
    self.to       && !self.from     ||
    self.next     && !self.previous ||
    self.previous && !self.next
  end

  def isolated?
    !(self.to || self.from || self.previous || self.next)
  end

  def link(goal)
    invalid1 = !self.half_linked? && !goal.half_linked?
    invalid2 = self.next && goal.previous
    invalid3 = self.previous && goal.next
    invalid4 = self.isolated? || goal.isolated?
    raise InvalidOperation.new("#link") if invalid1 || invalid2 || invalid3 || invalid4
    self.next = goal if !goal.previous
    self.previous = goal if !goal.next
  end

  def unlink(goal)
    raise InvalidOperation.new("#unlink") if !self.link_with?(goal)
    self.next, goal.previous = nil if self.next == goal && goal.previous == self
    goal.next, self.previous = nil if goal.next == self && self.previous == goal
  end

  def link_with?(goal)
    self.next == goal && goal.previous == self ||
    self.previous == goal && goal.next == self
  end

  def sub_goals
    self.start.dup.concat(self.end.dup)
  end

  def section_symbol
    return if self.section.nil?
    self.section.class.to_s.downcase[6..-1].to_sym
  end

  private

  def randstr(length=8)
    base = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    size = base.size
    re = '' << base[rand(size-10)]
    (length - 1).times {
      re << base[rand(size)]
    }
    re
  end

  def section_for_kind(klass)
    section if section.kind_of?(klass)
  end

  class << self
    def add_before(goal)
      raise InvalidOperation.new("::add_before") if goal.previous || goal.from
      goal.previous = self.new(:next => goal)
    end

    def add_after(goal)
      raise InvalidOperation.new("::add_after") if goal.next || goal.to
      goal.next = self.new(:previous => goal)
    end

    def add_between(goal1, goal2)
      invalid = goal1.next != goal2 || goal2.previous != goal1
      raise InvalidOperation.new("::add_between") if invalid
      goal           = self.new(:previous => goal1, :next => goal2)
      goal1.next     = goal
      goal2.previous = goal
    end
  end
end
