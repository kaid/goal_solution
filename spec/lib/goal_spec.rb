require "spec_helper"

describe Goal do
  let(:goal) {Goal.new}
  subject    {goal}

  describe Goal::Solution do
    let(:solution) {goal.add_solution}

    describe "#attach_to(goal)" do
      subject {solution}

      its(:master) {should be goal}
      specify {Goal::Solution.all.should include solution}
    end
  end

  describe Goal::Branch do
    class DummyElement
      attr_reader :previous, :next

      def initialize(previous: nil, anext: nil)
        @previous = previous
        @next     = anext
      end
    end

    let(:dummy1)  {DummyElement.new}
    let(:dummy2)  {DummyElement.new}
    let(:head)    {DummyElement.new(anext: dummy1)}
    let(:tail)    {DummyElement.new(previous: dummy2)}
    let(:branch1) {Goal::Branch.new(head: head)}
    let(:branch2) {Goal::Branch.new(tail: tail)}

    describe "#list" do
      specify {branch1.list.should eq [head, dummy1]}
      specify {branch2.list.should eq [dummy2, tail]}
    end
  end

  describe Goal::Add do
    let(:solution) {goal.add_solution}
    let(:head)     {solution.add_head}
    let(:tail)     {solution.add_tail}

    shared_examples "Goal::Add" do |what|
      which, awhich = :previous, :next if what == :before
      which, awhich = :next, :previous if what == :after

      let(:node) {return tail if what == :before;head if what == :after}
      let(:op)   {node.send "add_#{what}"}

      it "changes node.#{which}" do
        node.send("#{which}").should be nil
        new_node = op
        node.send("#{which}").should be new_node
      end

      specify {op.send("#{awhich}").should be node}

      context "invalid operation" do
        before do
          head.instance_variable_set("@next", tail)
          tail.instance_variable_set("@previous", head)
        end

        it {expect{op}.to raise_error(Goal::InvalidOperation)}
      end
    end

    describe "#add_before(node)" do
      it_should_behave_like "Goal::Add", :before
    end

    describe "#add_after(node)" do
      it_should_behave_like "Goal::Add", :after
    end
  end

  describe Goal::Insert do
    let(:solution) {goal.add_solution}
    let(:head)     {solution.add_head}
    let(:tail)     {solution.add_tail}

    before do
      head.instance_variable_set("@next", tail)
      tail.instance_variable_set("@previous", head)
    end

    describe "#insert_between(node)" do
      let(:op) {head.insert_between(tail)}

      it "changes head's next" do
        head.next.should be tail
        node = op
        head.next.should be node
      end

      it "changes tail's previous" do
        tail.previous.should be head
        node = op
        tail.previous.should be node
      end

      specify {op.previous.should be head}
      specify {op.next.should be tail}
    end

    describe "#remove" do
      let(:node) {head.insert_between(tail)}
      let(:op)   {node.remove}

      it {expect{op}.to change{head.next}.from(node).to(tail)}
      it {expect{op}.to change{tail.previous}.from(node).to(head)}
    end
  end

  describe Goal::Link do
    let(:solution) {goal.add_solution}
    let(:head)     {solution.add_head}
    let(:tail)     {solution.add_tail}

    describe "#link(node)" do
      let(:op1) {head.link(tail)}
      let(:op2) {tail.link(head)}

      it {expect{op1}.to change{head.next}.from(nil).to(tail)}
      it {expect{op1}.to change{tail.previous}.from(nil).to(head)}
      it {expect{op2}.to change{head.next}.from(nil).to(tail)}
      it {expect{op2}.to change{tail.previous}.from(nil).to(head)}

      context "invalid operation" do
        let(:node) {Goal.new}
        let(:op)   {node.link(head)}

        it {expect{op}.to raise_error(Goal::InvalidOperation)}
      end
    end
    
    describe "#unlink(node)" do
      let(:op1) {head.unlink(tail)}
      let(:op2) {tail.unlink(head)}

      before {head.link(tail)}

      it {expect{op1}.to change{head.next}.from(tail).to(nil)}
      it {expect{op1}.to change{tail.previous}.from(head).to(nil)}
      it {expect{op2}.to change{head.next}.from(tail).to(nil)}
      it {expect{op2}.to change{tail.previous}.from(head).to(nil)}

      context "invalid operation" do
        let(:node) {Goal.new}
        let(:op)   {node.link(head)}

        it {expect{op}.to raise_error(Goal::InvalidOperation)}
      end
    end
  end

#   context "XML serialization/deserialization" do
#     specify do
#       goal = Goal.new
#       goal.start.create
#       goal.end.create
#       Goal.add_after(goal.start.first)
#       Goal.add_before(goal.end.first)
#       goal.start.first.next.link(goal.end.first.previous)

#       xml = goal.to_xml

#       path = goal.save.path
#       Goal.instance_variable_set("@all", [])
#       goal = nil

#       agoal = Goal.load_xml path

#       agoal.to_xml.should eq xml
#       FileUtils.rm(path)
#     end
#   end
# e
end
