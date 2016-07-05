IdeaMapr.Models.SurveyQuestion = Backbone.Model.extend
  defaults: ->
    view_request: 0
    answered: false
    promoted: 0
    
  urlRoot: '/survey_question'

  set_field_details: ->
    unless @field_details
      @field_details = new IdeaMapr.Collections.DetailsCollection()
      @field_details.survey_question_id = @get('id')
    @field_details
    
  set_idea_list: ->
    unless @idea_list
      @idea_list = new IdeaMapr.Collections.IdeaCollection()
      @idea_list.survey_question_id = @get('id')
    @idea_list

  trigger_fetches: ->
    if @hasOwnProperty 'idea_list'
      @idea_list.fetch()
    if @hasOwnProperty 'field_details'
      @field_details.fetch()
            
  component_data: ->
    # Return the key information needed to associate either details or ideas with a SQ

    if @hasOwnProperty('field_details') and (@get('question_type') == 5 or @get('question_type') == 6)
      @field_details.question_type = @get('question_type')
      c_data = @field_details.serialize()
    else
      # the underlying idea management view would have added this property
      @assigned_ideas.question_type = @get('question_type')
      c_data = @assigned_ideas.serialize()
    
    c_data
