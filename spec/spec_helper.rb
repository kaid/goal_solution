require "bundler"
require "./lib/models/goal"
Bundler.require(:test)
require "pry"

# controler 层测试需要的配置
require 'rack/test'
module RSpecMixin
  include Rack::Test::Methods
  def app() GoalSolution end
end
RSpec.configure { |c| c.include RSpecMixin }
