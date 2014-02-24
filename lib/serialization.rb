require "nokogiri"

class Goal
  module Serialization
    def self.included(base)
      base.extend  ClassMethods
      base.include InstanceMethods
    end

    module InstanceMethods
      def to_xml(builder)
        builder.goal {
          builder.id_ self.id

          if self.name
            builder.name_ self.name
          end

          if self.desc
            builder.desc self.desc
          end

          if self.section_symbol
            builder.section self.section_symbol
          end

          if self.init_desc
            builder.section self.init_desc
          end

          if self.finish_desc
            builder.section self.finish_desc
          end

          if self.previous
            builder.previous_id self.previous.id
          end

          if self.next
            builder.next_id self.next.id
          end

          if self.sub_goals.any?
            builder.subs {
              self.sub_goals.each do |sgoal|
                current_goal = sgoal

                builder.sub {
                  while current_goal
                    current_goal.to_xml(builder)
                    current_goal = current_goal.next
                  end
                }
              end
            }
          end
        }
      end
    end

    module ClassMethods
      def to_xml
        Nokogiri::XML::Builder.new do |builder|
          builder.root {
            self.toplevel_goals.each do |tgoal|
              tgoal.to_xml(builder)
            end
          }
        end.to_xml
      end

      def save!
        path = File.expand_path("../goals.xml", __FILE__)
        File.open(path, "w") do |f|
          f << self.to_xml
          puts
        end
      end
    end
  end
end
