class PublicInfoController < ApplicationController
  # Only renders JSON
  def double_bundle
    if params[:for_survey] &&
       (@survey = Survey.find_by_public_link(params[:for_survey]))
      # This is going to be a list of lists ... for a survey ... so it has to be returned as if it's a 
      # model. All ideas for a survey - would an admin ever ask for this? TODO
      
      list_of_lists = SurveyQuestion.includes(:question_assignments).
                      order('question_assignments.ordering asc').where(question_assignments: {survey_id: @survey.id}).
                      all.each_with_index.map do |sq, index|
        ret = {question_index: index}
        
        ret.merge!(
          if sq.question_type == SurveyQuestion::QuestionType::RADIO_CHOICES ||
             sq.question_type == SurveyQuestion::QuestionType::TEXT_FIELDS
            {type: 'detail', data: sq.question_detail.details_list}
          elsif sq.question_type == SurveyQuestion::QuestionType::NEW_IDEA
            {type: 'new_idea', data: ({id: -1, title: 'dummy'})}
          else
            data_array = IdeaAssignment.joins(:idea).includes(:idea).
                         where(idea_assignments: {groupable_id: sq.id, groupable_type: 'SurveyQuestion'}).
                         order('idea_assignments.ordering ASC').all

            # construct the idea attributes here. Might contain cart amount for budget questions etc.
            {type: 'idea', data: data = data_array.map do |idea_assignment|
               idea = idea_assignment.idea
               
               memo = {id: idea.id, title: idea.title, description: idea.description,
                       component_rank: idea_assignment.ordering}
               if sq.question_type == SurveyQuestion::QuestionType::BUDGETING
                 memo.merge!({cart_amount: idea_assignment.budget})
               end
               memo[:attachments] = idea.download_files_hash
               memo
             end}
          end
        )
        
        ret
      end
      @all_ideas = {list_of_lists: list_of_lists}
    else
      @all_ideas = {list_of_lists: []}
    end
    render json: @all_ideas
  end
end
