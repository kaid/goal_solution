require "spec_helper"

describe Goal do
  let(:goal) {Goal.new}
  subject    {goal}

  its(:start) {should be_an Goal::Section}
  its(:end)   {should be_an Goal::Section}

  describe Goal::Section do
    subject {Goal::Section.new}

    it {should be_an Array}
  end

  shared_examples "Goal::Section" do |klass|
    meth = :start if klass == Goal::Start
    meth = :end   if klass == Goal::End

    let(:section) {goal.send meth}

    specify {section.should be_a Goal::Section}

    describe "#create(params)" do
      subject {section.create}
      
      it      {should be_a Goal}
      specify {section.should include subject}

      before do
        @from, @to = section, nil if klass == Goal::Start
        @from, @to = nil, section if klass == Goal::End
      end

      its(:section) {should be section}
      its(:from)    {should be @from}
      its(:to)      {should be @to}
    end
  end

  describe Goal::Start do
    it_should_behave_like "Goal::Section", Goal::Start
  end

  describe Goal::End do
    it_should_behave_like "Goal::Section", Goal::End
  end

  let(:node1) {goal.start.last}
  let(:node2) {goal.end.last}

  before do
    goal.start.create
    goal.end.create
  end

  context "add node before/after half linked node" do
    shared_examples "create&link node" do |what|
      which, awhich = :previous, :next if what == :before
      which, awhich = :next, :previous if what == :after

      let(:node) {return node2 if what == :before;node1 if what == :after}
      let(:op)   {Goal.send "add_#{what}", node}

      it "changes node.#{which}" do
        node.send("#{which}").should be nil
        new_node = op
        node.send("#{which}").should be new_node
      end

      specify {op.send("#{awhich}").should be node}

      context "invalid operation" do
        before do
          node1.instance_variable_set(:"@next", node2)
          node2.instance_variable_set(:"@previous", node1)
        end

        it {expect{op}.to raise_error(Goal::InvalidOperation)}
      end
    end

    describe "::add_before(node)" do
      it_should_behave_like "create&link node", :before
    end

    describe "::add_after(node)" do
      it_should_behave_like "create&link node", :after
    end
  end

  context "inserting and removing node" do
    before do
      node1.instance_variable_set(:"@next", node2)
      node2.instance_variable_set(:"@previous", node1)
    end

    describe "::add_between(node1, node2)" do
      let(:op) {Goal.add_between(node1, node2)}

      it "changes node1's next" do
        node1.next.should be node2
        node = op
        node1.next.should be node
      end

      it "changes node2's previous" do
        node2.previous.should be node1
        node = op
        node2.previous.should be node
      end

      specify {op.previous.should be node1}
      specify {op.next.should be node2}
    end

    describe "#remove" do
      let(:node) {Goal.add_between(node1, node2)}
      let(:op)   {node.remove}

      it {expect{op}.to change{node1.next}.from(node).to(node2)}
      it {expect{op}.to change{node2.previous}.from(node).to(node1)}
    end
  end

  context "link half linked nodes" do
    describe "#link(node)" do
      let(:op1) {node1.link(node2)}
      let(:op2) {node2.link(node1)}

      it {expect{op1}.to change{node1.next}.from(nil).to(node2)}
      it {expect{op1}.to change{node2.previous}.from(nil).to(node1)}
      it {expect{op2}.to change{node1.next}.from(nil).to(node2)}
      it {expect{op2}.to change{node2.previous}.from(nil).to(node1)}

      context "invalid operation" do
        let(:node) {Goal.new}
        let(:op)   {node.link(node1)}

        it {expect{op}.to raise_error(Goal::InvalidOperation)}
      end
    end
    
    describe "#unlink(node)" do
      let(:op1) {node1.unlink(node2)}
      let(:op2) {node2.unlink(node1)}

      before {node1.link(node2)}

      it {expect{op1}.to change{node1.next}.from(node2).to(nil)}
      it {expect{op1}.to change{node2.previous}.from(node1).to(nil)}
      it {expect{op2}.to change{node1.next}.from(node2).to(nil)}
      it {expect{op2}.to change{node2.previous}.from(node1).to(nil)}

      context "invalid operation" do
        let(:node) {Goal.new}
        let(:op)   {node.link(node1)}

        it {expect{op}.to raise_error(Goal::InvalidOperation)}
      end
    end
  end

  context "XML serialization/deserialization" do
    
  end
end
