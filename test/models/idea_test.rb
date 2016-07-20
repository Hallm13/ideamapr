require 'test_helper'

class IdeaTest < ActiveSupport::TestCase
  test '#surveys' do
    assert_equal 1, ideas(:idea_1).surveys.count
  end
end
