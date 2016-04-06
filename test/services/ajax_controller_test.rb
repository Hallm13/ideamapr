module Ajax
  class LibraryTest < ActiveSupport::TestCase
    test 'get survey question map' do
      data = Ajax::Library.route_action("survey_question/get_prompt_map/")
      assert_equal 5, data[:data].keys.size
    end
  end
end
