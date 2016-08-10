require 'test_helper'
class IndividualAnswersControllerTest < ActionController::TestCase
  describe '#create' do
    before do
      @answer_1_publ_survey = {survey_question_id: survey_questions(:sq_1).id,
                               survey_token: surveys(:published_survey).public_link}
    end
  
    it 'invalid data' do
      refute_difference('IndividualAnswer.count') do
        post :create, response_data: ({list: [1,2]}).to_json
      end

      refute_difference('IndividualAnswer.count') do
        post :create, sqn_id: survey_questions(:sq_1).id, survey_token: 'blabla', response_data: ({data: [1]}.to_json)
      end
      assert_equal ({"success"=>false, "message"=>"invalid parameters"}), JSON.parse(response.body)
    end

    it 'respects db errors' do
      IndividualAnswer.any_instance.stubs(:save).returns false
      post :create, @answer_1_publ_survey.merge({response_data: ({data: [new_idea_hash, new_idea_hash]}).to_json})
      refute JSON.parse(response.body)[:success]
      IndividualAnswer.any_instance.unstub(:save)
    end
    
    it 'valid data for new idea question type' do
      response_count = Response.count
      idea_count = Idea.count
      assert_difference('IndividualAnswer.count', 1) do
        post :create, @answer_1_publ_survey.merge({response_data: ({data: [new_idea_hash, new_idea_hash]}).to_json})
      end

      assert_equal idea_count + 2, Idea.count
      assert_equal response_count + 1, Response.count
    end

    it 'cookied requests overwrite' do
      cookies['_ideamapr_response_key'] = 'testercookie'
      response_count = Response.count
      assert_difference('IndividualAnswer.count', 1) do
        post :create, @answer_1_publ_survey.merge({response_data: ({data: [1]}).to_json})
        post :create, @answer_1_publ_survey.merge({response_data: ({data: [2]}).to_json})
      end

      # There's only one new Response, though two fragments were saved
      assert_equal response_count + 1, Response.count
      assert_equal 'testercookie', Response.last.respondent.cookie_key
      
      assert_equal 2, IndividualAnswer.last.response_data[0]
    end

    after do
      cookies['_ideamapr_response_key'] = nil      
    end
  end

  describe '#update: close out survey' do
    it 'can use valid data' do
      cookies['_ideamapr_response_key'] = 'testercookie'
      refute surveys(:published_survey).responses.first.closed
      assert_difference('Respondent.count') do
        put :update, id: surveys(:published_survey).public_link
      end

      # Only one response in fixtures right now; we added one above.
      assert surveys(:published_survey).responses.all[1].closed
    end

    describe 'errors' do
      it 'handles broken survey id' do
        refute_difference('Respondent.count') do
          put :update, id: -1
        end
        refute JSON.parse(response.body)[:success]
      end
      it 'handles bad json' do
        answer_1_publ_survey = {survey_question_id: survey_questions(:sq_1).id,
                                survey_token: surveys(:published_survey).public_link}
        refute_difference('Respondent.count') do
          post :create, answer_1_publ_survey.merge({response_data: '[thisisnotjson[]'})
        end
        refute JSON.parse(response.body)[:success]
      end        
    end
    
    after do
      cookies['_ideamapr_response_key'] = 'testercookie'
    end
  end
  private

  def new_idea_hash
    {title: 'title title' + Random.rand(100).to_s, description: 'description: ' + Random.rand(100).to_s}
  end
end
