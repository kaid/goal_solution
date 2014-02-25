require "nokogiri"
require "active_support/core_ext"

class Goal
  module Serialization
    def self.included(base)
      base.extend  ClassMethods
      base.include InstanceMethods
    end

    module InstanceMethods
      def to_xml
        Nokogiri::XML::Builder.new do |builder|
          self.goal_xml(builder)
        end.to_xml
      end

      def fields_xml(builder)
        self.class.serialize_fields.each do |field|
          value = self.send(field)
          builder.send("#{field}_", value) if value
        end
      end

      def goal_xml(builder)
        builder.goal {
          fields_xml(builder)

          builder.solutions {
            [:start, :end].each do |sec|
              section = self.send(sec)

              if section.any?
                section.each do |sgoal|
                  next if sec == :end && sgoal.in_full_solution?

                  current_goal = sgoal

                  builder.solution {
                    while current_goal
                      current_goal.goal_xml(builder)
                      current_goal = current_goal.next if sec == :start
                      current_goal = current_goal.previous if sec == :end
                    end
                  }
                end
              end
            end
          }
        }
      end

      def init_from_deserialization
        [:under, :next, :previous].each do |field|
          _rel_id = instance_variable_get("@#{field}_id")
          if _rel_id
            _rel = self.class.find(_rel_id)
            instance_variable_set("@#{field}", _rel)
          end
        end

        [:start, :end].each do |sec|
          _sec_type = instance_variable_get("@section_type")
          self.under.send(sec) << self if self.under && _sec_type == sec.to_s
        end

        self
      end

      def save
        path = File.expand_path("../../goals/#{self.id}.xml", __FILE__)
        File.open(path, "w") do |f|
          f << self.to_xml
        end
      end
    end

    module ClassMethods
      def serialize(*fields)
        serialize_fields.concat fields
      end

      def serialize_fields
        @serialize_fields ||= []
      end

      def load_xml(file_path)
        File.open(file_path, "r") do |file|
          doc = Nokogiri::XML(file)
          goals = doc.xpath("//goal")
          goals.xpath("//solutions").remove
          goals.map do |doc|
            attrs = Hash.from_xml(doc.to_xml)["goal"]
            Goal.new(attrs)
          end.map {|goal| goal.init_from_deserialization}.first
        end
      end
    end
  end
end
