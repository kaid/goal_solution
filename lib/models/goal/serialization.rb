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
          self.xml_with(builder)
        end.to_xml
      end

      def fields_xml(builder)
        self.class.serialize_fields.each do |field|
          value = self.send(field)
          builder.send("#{field}_", value) if value
        end
      end

      def xml_with(builder)
        builder.goal {
          fields_xml(builder)

          if self.solutions.any?
            builder.solutions {
              self.solutions.each do |solution|
                solution.xml_with(builder)
              end
            }
          end
        }
      end

      def init_with(xml)
        xml.children.each do |child|
          if child.name == "solutions"
            child.children.each do |solution_el|
              self.add_solution.init_with(solution_el)
            end
            next self
          end
          self.update(child.name => child.text)
        end
        self
      end

      # def save
      #   path = File.expand_path("../../goals/#{self.id}.xml", __FILE__)
      #   File.open(path, "w") do |f|
      #     f << self.to_xml
      #   end
      # end
    end

    module ClassMethods
      def serialize(*fields)
        serialize_fields.concat fields
      end

      def serialize_fields
        @serialize_fields ||= []
      end

      def parse(doc)
        doc.xpath("//text()")
           .select {|i| i.content.match(/$\n\s*/)}
           .each(&:remove)
        goal = self.new.init_with(doc.children.first)
        goal
      end

      def load_xml(file_path)
        Goal.instance_variable_set("@all", [])
        Goal::Solution.instance_variable_set("@all", [])

        File.open(file_path, "r") do |file|
          self.parse Nokogiri::XML(file)
        end
      end
    end
  end
end
