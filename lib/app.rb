# -*- coding: utf-8 -*-
require "bundler"
Bundler.setup(:default)
require "sinatra"
require "sinatra/reloader"

class GoalSolution < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  get "/" do
    "世界你好！"
  end
end
