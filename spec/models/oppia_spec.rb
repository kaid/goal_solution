require "spec_helper"

describe Oppia do
  let(:yaml) {"./spec/resources/oppia.yaml"}
  let(:exp_hash) {YAML.load_file(yaml)}

  describe Oppia::Exploration do
    subject {Oppia::Exploration.from_yaml(yaml)}

    specify {subject.states["check-mobile-device-type"].should be_a Oppia::State}
  end

  describe Oppia::State do
    let(:state_hash) {exp_hash["states"]["check-mobile-device-type"]}
    subject {Oppia::State.new(state_hash)}

    its(:widget) {should be_a Oppia::Widget}
    specify {subject.contents.first.should be_a Oppia::Content}
  end

  describe Oppia::Content do
    let(:content_hash) {exp_hash["states"]["check-mobile-device-type"]["content"][0]}
    subject {Oppia::Content.new(content_hash)}

    its(:type) {should eq "text"}
    its(:value) {should_not be_blank}
  end

  describe Oppia::RuleSpec do
    let(:rule_spec_hash) {exp_hash["states"]["check-mobile-device-type"]["widget"]["handlers"][0]["rule_specs"][0]}
    let(:fake_state) {double()}
    subject {Oppia::RuleSpec.new(rule_spec_hash)}
    before {Oppia::Exploration.stub(:states) {{"the-android-and-web-weixin-method" => fake_state}}}

    its(:definition) {should be_a Hash}
    its(:dest) {should be fake_state}
    its(:feedback) {should be_an Array}
    its(:param_changes) {should be_an Array}
  end

  describe Oppia::Handler do
    let(:handler_hash) {exp_hash["states"]["check-mobile-device-type"]["widget"]["handlers"][0]}
    subject {Oppia::Handler.new(handler_hash)}

    its(:rule_specs) {should be_an Array}
    its(:name) {should eq "submit"}
    specify {subject.rule_specs.first.should be_a Oppia::RuleSpec}
  end
end
