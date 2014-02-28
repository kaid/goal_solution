require "spec_helper"

describe GoalSolution do
  it "root" do
    get "/"
    last_response.should be_ok
  end
end