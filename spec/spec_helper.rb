# -*- coding: utf-8 -*-
ENV['RACK_ENV'] = 'test'
require "bundler"
require "./lib/app"
require "./lib/models/goal"
require "./lib/models/oppia"
Bundler.require(:test)
require "pry"

# controler 层测试需要的配置
require 'rack/test'
module RSpecMixin
  include Rack::Test::Methods
  def app() GoalSolution end
end
RSpec.configure do |config|

  config.include RSpecMixin

  config.before :each do
    DatabaseCleaner[:mongoid].strategy = :truncation
    DatabaseCleaner[:mongoid].start
  end

  config.after :each do
    DatabaseCleaner[:mongoid].clean
  end
end
