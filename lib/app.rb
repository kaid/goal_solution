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

  get "/do" do
    case params["action"]
    when "add_solution"
      add_solution(params["params"]["goal_id"])
    when "remove_solution"
      remove_solution(params["params"]["solution_id"])
    when "add_goal"
      solution_id = params["params"]["solution_id"]
      name = params["params"]["goal"]["name"]
      direction = params["params"]["goal"]["direction"]
      target = params["params"]["goal"]["target"]
      add_goal(solution_id, name, direction, target)
    when "remove_goal"
      remove_goal(params["params"]["goal_id"])
    end
  end

  def add_solution(goal_id)
    goal = Goal.find(goal_id)
    solution = goal.create_solution
    {:solution_id => solution.id}
  end

  def remove_solution(solution_id)
    solution = Solution.find(solution_id)
    solution.destroy
    {:status => 'ok'}
  end

  def add_goal(solution_id, name, direction, target)
    solution = Solution.find(solution_id)
    goal = solution.create_goal(
      :name => name, :direction => direction, :target => target
    )
    {:goal_id => goal.id}
  end

  def remove_goal(goal_id)
    goal = Goal.find(goal_id)
    goal.destroy
    {:status => 'ok'}
  end
end
