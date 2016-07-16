require 'test_helper'

class RespondentTest < ActiveSupport::TestCase
  def setup
    @respondent = respondents(:respondent_1)
  end

  test 'dependence' do
    assert_difference('IndividualAnswer.count', -1) do
      @respondent.destroy
    end
  end
end
