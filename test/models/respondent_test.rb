require 'test_helper'

class RespondentTest < ActiveSupport::TestCase
  def setup
    @respondent = respondents(:respondent_1)
  end

  test 'dependence' do
    ct = IndividualAnswer.where(respondent_id: @respondent.id).count
    assert_difference('IndividualAnswer.count', -1 * ct) do
      @respondent.destroy
    end
  end
end
