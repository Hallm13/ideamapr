class PublicInfoController < ApplicationController
  # Only renders JSON
  def double_bundle
    if params[:for_survey] &&
       (@survey = Survey.find_by_public_link(params[:for_survey]))
      # This is going to be a list of lists ... for a survey ... so it has to be returned as if it's a 
      # model. All ideas for a survey - would an admin ever ask for this? TODO
      list_of_lists = @survey.question_assignments.order(:ordering).map do |sq_assign|
        # TODO this is _so_ inefficient. N+1 queries, etc.
        sq = sq_assign.survey_question
        if sq.question_type == SurveyQuestion::QuestionType::RADIO_CHOICES ||
           sq.question_type == SurveyQuestion::QuestionType::TEXT_FIELDS
          {type: 'detail', data: sq.question_detail.details_list}
        else
          if sq.question_type == SurveyQuestion::QuestionType::BUDGETING
            field_list = ['ideas.id', :title, :description, :budget]
          else
            field_list = ['ideas.id', :title, :description]
          end
          data_array = Idea.joins(:idea_assignments).includes(:idea_assignments).
                       where(idea_assignments: {groupable_id: sq.id, groupable_type: 'SurveyQuestion'}).
                       order('idea_assignments.ordering ASC').pluck(*field_list)
          ret = {type: 'idea', data: data_array.map do |val_set|
                   [:id, :title, :description, :cart_amount].zip(val_set).inject({}) do |memo, pair|
                     if pair[1].present?
                       memo[pair[0]] = pair[1]
                     end
                     memo
                   end
                 end}

          Rails.logger.debug "Producting #{ret[:data]}"
          ret
        end
      end
      @all_ideas = {list_of_lists: list_of_lists}
    else
      @all_ideas = {list_of_lists: []}
    end
    render json: @all_ideas
  end
end
