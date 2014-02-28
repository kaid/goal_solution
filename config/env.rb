require "bundler"
Bundler.setup(:default)
require "pry"
require "mongoid"
require "sinatra"

Mongoid.load!("./config/mongoid.yml")
