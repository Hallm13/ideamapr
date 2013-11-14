require 'spec_helper'

describe Task do
  context 'logged out' do
    it "should not be permitted to create a task" do
      (Ability.new User.new).should_not be_able_to(:create, Task.new)
    end
  end

end
