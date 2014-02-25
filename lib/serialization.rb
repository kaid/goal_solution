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

          if self.solutions.any?
            builder.solutions {
              self.solutions.each do |solution|
                solution.solution_xml(builder)
              end
            }
          end
        }
      end

      def init_from_deserialization
        root = self.class.all.first
        root.start << self if @previous_id == "::START"
        root.end   << self if @next_id == "::END"
        self.previous = self.class.find(@previous_id)
        self.next = self.class.find(@next_id)
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

      def parse(doc)
        goals = doc.xpath("//goal")
        goals.xpath("//solutions").remove
        goals.map do |doc|
          attrs = Hash.from_xml(doc.to_xml)["goal"]
          Goal.new(attrs).init_from_deserialization
        end.first
      end

      def load_xml(file_path)
        File.open(file_path, "r") do |file|
          self.parse Nokogiri::XML(file)
        end
      end
    end
  end
end
