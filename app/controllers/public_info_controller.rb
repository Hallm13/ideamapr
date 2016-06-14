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
        ideas = Idea.where('id in (?)', sq.idea_assignments.order(:ordering).pluck(:idea_id))
      end
      @all_ideas = {list_of_lists: list_of_lists}
    else
      @all_ideas = {list_of_lists: []}
    end
    render json: @all_ideas
  end
end
