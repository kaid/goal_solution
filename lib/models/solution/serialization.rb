require "nokogiri"

class Solution
  module Serialization
    def xml_with(builder)
      builder.solution {
        self.goals.each do |goal|
          goal.xml_with(builder)
        end
      }
    end
  end
end
