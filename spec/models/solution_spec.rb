require "spec_helper"

describe Solution do
  let(:master)   {Goal.create}
  let(:solution) {master.solutions.create}

  describe "#create_goal(name: name, direction: direction, target: target)" do
    def create_goal(name, dir, target)
      solution.create_goal(name: name, direction: dir, target: target)
    end

    let(:goal1) {create_goal("goal1", "before", goal3.id)}
    let(:goal2) {create_goal("goal2", "after", goal1.id)}
    let(:goal3) {create_goal("goal3", "after", solution.begin.id)}
    
    specify {expect{goal3}.to change{solution.goals.count}.by(1)}
    specify {goal3.prev_id.should eq solution.begin.id}
    specify {goal3.next_id.should eq nil}

    specify do
      goal3.reload.prev_id.should eq solution.begin.id
      goal1
      goal3.reload.prev_id.should eq goal1.id
    end

    specify {goal1.prev_id.should eq solution.begin.id}
    specify {goal1.next_id.should eq goal3.id}

    specify do
      goal1
      goal3.reload.prev_id.should eq goal1.id
      goal2
      goal3.reload.prev_id.should eq goal2.id
    end

    specify do
      goal1.reload.next_id.should eq goal3.id
      goal2
      goal1.reload.next_id.should eq goal2.id
    end
    specify {goal2.prev_id.should eq goal1.id}
    specify {goal2.next_id.should eq goal3.id}
  end
end
