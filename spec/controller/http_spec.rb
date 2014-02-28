require "spec_helper"

describe GoalSolution do

  it "创建一个新的 goal" do
    put "/do", {:action => "add_goal", :params => {:goal => {:name => "root"}}}
    last_response.should be_ok
    goal = Goal.last
    goal.name.should == "root"
  end

  describe "编辑 gaol" do
    before{
      @goal = Goal.create(:name => "root")
    }

    it "增加 solution" do
      put "/do", {:action => "add_solution", :params => {:goal_id => @goal.id}}
      solution_id = JSON.parse(last_response.body)["solution_id"]
      @goal.solutions.count.should == 1
      @goal.solutions.last.id.to_s.should == solution_id.to_s
    end

    describe "移除 solution" do
      before {
        @solution = @goal.create_solution
      }

      it {
        put "/do", {:action => "remove_solution", :params => {:solution_id => @solution.id}}
        JSON.parse(last_response.body).should == {"status"=>"ok"}
        @goal.reload
        @goal.solutions.count.should == 0
      }
    end

    describe "增加 goal" do
      before {
        @solution = @goal.create_solution
      }

      it {
        put "/do", {:action => "add_goal", :params => {:solution_id => @solution.id, :goal => {:name => "goal1", :direction => "after", :target => "::BEGIN"}}}
        goal_id = JSON.parse(last_response.body)["goal_id"]
        @solution.goals.count.should == 1 
        @solution.goals.last.name.should == "goal1"
        @solution.goals.last.id.to_s.should == goal_id.to_s
      }
    end

    describe "移除 goal" do
      before {
        @solution = @goal.create_solution
        @goal = @solution.create_goal(
          :name => "goal1", :direction => "after", :target => "::BEGIN"
        )
      }

      it {
        put "/do", {:action => "remove_goal", :params => {:goal_id => @goal.id}}
        JSON.parse(last_response.body).should == {"status"=>"ok"}
        @solution.goals.count.should == 0
      }
    end

  end

end