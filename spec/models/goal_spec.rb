require "spec_helper"

describe Goal do
  let(:master)   {Goal.create(name: "master")}
  let(:solution) {master.solutions.create}
  let(:goal1)    {solution.goals.create}
  let(:goal2)    {solution.goals.create}

  describe "#prev=(goal)" do
    let(:op1) {goal1.prev = goal2}
    let(:op2) {goal2.prev = solution.begin}

    specify {expect{op1}.to change{goal1.prev}.from(nil).to(goal2)}
    specify {expect{op1}.to change{goal2.next}.from(nil).to(goal1)}
    specify {expect{op1}.to change{goal1.prev_id}.from(nil).to(goal2.id)}
    specify {expect{op1}.to change{goal2.next_id}.from(nil).to(goal1.id)}

    specify {expect{op2}.to change{goal2.prev}.from(nil).to(solution.begin)}
    specify {expect{op2}.to change{solution.begin.next}.from(nil).to(goal2)}
    specify {expect{op2}.to change{goal2.prev_id}.from(nil).to(solution.begin.id)}
    specify {expect{op2}.to change{solution.begin.next_id}.from(nil).to(goal2.id)}
  end

  describe "#next=(goal)" do
    let(:op1) {goal1.next = goal2}
    let(:op2) {goal2.next = solution.end}

    specify {expect{op1}.to change{goal1.next}.from(nil).to(goal2)}
    specify {expect{op1}.to change{goal2.prev}.from(nil).to(goal1)}
    specify {expect{op1}.to change{goal1.next_id}.from(nil).to(goal2.id)}
    specify {expect{op1}.to change{goal2.prev_id}.from(nil).to(goal1.id)}

    specify {expect{op2}.to change{goal2.next}.from(nil).to(solution.end)}
    specify {expect{op2}.to change{solution.end.prev}.from(nil).to(goal2)}
    specify {expect{op2}.to change{goal2.next_id}.from(nil).to(solution.end.id)}
    specify {expect{op2}.to change{solution.end.prev_id}.from(nil).to(goal2.id)}
  end

  # describe Goal::Link do
  #   let(:solution) {goal.add_solution}
  #   let(:head)     {solution.add_head}
  #   let(:tail)     {solution.add_tail}

  #   describe "#link(node)" do
  #     let(:op1) {head.link(tail)}
  #     let(:op2) {tail.link(head)}

  #     it {expect{op1}.to change{head.next}.from(nil).to(tail)}
  #     it {expect{op1}.to change{tail.previous}.from(nil).to(head)}
  #     it {expect{op2}.to change{head.next}.from(nil).to(tail)}
  #     it {expect{op2}.to change{tail.previous}.from(nil).to(head)}

  #     context "invalid operation" do
  #       let(:node) {Goal.new}
  #       let(:op)   {node.link(head)}

  #       it {expect{op}.to raise_error(Goal::InvalidOperation)}
  #     end
  #   end
    
  #   describe "#unlink(node)" do
  #     let(:op1) {head.unlink(tail)}
  #     let(:op2) {tail.unlink(head)}

  #     before {head.link(tail)}

  #     it {expect{op1}.to change{head.next}.from(tail).to(nil)}
  #     it {expect{op1}.to change{tail.previous}.from(head).to(nil)}
  #     it {expect{op2}.to change{head.next}.from(tail).to(nil)}
  #     it {expect{op2}.to change{tail.previous}.from(head).to(nil)}

  #     context "invalid operation" do
  #       let(:node) {Goal.new}
  #       let(:op)   {node.link(head)}

  #       it {expect{op}.to raise_error(Goal::InvalidOperation)}
  #     end
  #   end
  # end

  context "XML serialization/deserialization" do
    def create_goal(name, dir, target)
      solution.create_goal(name: name, direction: dir, target: target)
    end

    let(:goal1) {create_goal("goal1", "before", goal3.id)}
    let(:goal2) {create_goal("goal2", "after", goal1.id)}
    let(:goal3) {create_goal("goal3", "after", solution.begin.id)}
    
    pending
  end
end
