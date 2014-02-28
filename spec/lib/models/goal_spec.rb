require "spec_helper"

describe Solution do
  describe "#create_goal(name: name, direction: direction, target: target)" do
    
  end
end

describe Goal do
  let(:master)   {Goal.create}
  let(:solution) {Solution.create}
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

  # describe Goal::Add do
  #   let(:solution) {goal.add_solution}
  #   let(:head)     {solution.add_head}
  #   let(:tail)     {solution.add_tail}

  #   shared_examples "Goal::Add" do |what|
  #     which, awhich = :previous, :next if what == :before
  #     which, awhich = :next, :previous if what == :after

  #     let(:node) {return tail if what == :before;head if what == :after}
  #     let(:op)   {node.send "add_#{what}"}

  #     it "changes node.#{which}" do
  #       node.send("#{which}").should be nil
  #       new_node = op
  #       node.send("#{which}").should be new_node
  #     end

  #     specify {op.send("#{awhich}").should be node}

  #     context "invalid operation" do
  #       before do
  #         head.instance_variable_set("@next", tail)
  #         tail.instance_variable_set("@previous", head)
  #       end

  #       it {expect{op}.to raise_error(Goal::InvalidOperation)}
  #     end
  #   end

  #   describe "#add_before(node)" do
  #     it_should_behave_like "Goal::Add", :before
  #   end

  #   describe "#add_after(node)" do
  #     it_should_behave_like "Goal::Add", :after
  #   end
  # end

  # describe Goal::Insert do
  #   let(:solution) {goal.add_solution}
  #   let(:head)     {solution.add_head}
  #   let(:tail)     {solution.add_tail}

  #   before do
  #     head.instance_variable_set("@next", tail)
  #     tail.instance_variable_set("@previous", head)
  #   end

  #   describe "#insert_between(node)" do
  #     let(:op) {head.insert_between(tail)}

  #     it "changes head's next" do
  #       head.next.should be tail
  #       node = op
  #       head.next.should be node
  #     end

  #     it "changes tail's previous" do
  #       tail.previous.should be head
  #       node = op
  #       tail.previous.should be node
  #     end

  #     specify {op.previous.should be head}
  #     specify {op.next.should be tail}
  #   end

  #   describe "#remove" do
  #     let(:node) {head.insert_between(tail)}
  #     let(:op)   {node.remove}

  #     it {expect{op}.to change{head.next}.from(node).to(tail)}
  #     it {expect{op}.to change{tail.previous}.from(node).to(head)}
  #   end
  # end

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

  # context "XML serialization/deserialization" do
  #   specify do
  #     goal = Goal.new
  #     solution = goal.add_solution
  #     solution.add_head
  #     solution.add_tail
  #     solution.head.add_after
  #     solution.tail.add_before
  #     solution.head.next.link(solution.tail.previous)

  #     xml   = goal.to_xml
  #     path  = goal.save.path
  #     agoal = Goal.load_xml path

  #     agoal.to_xml.should eq xml
  #     FileUtils.rm(path)
  #   end
  # end
end
