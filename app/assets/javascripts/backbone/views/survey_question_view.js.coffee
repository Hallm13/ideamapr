IdeaMapr.Views.SurveyQuestionView = IdeaMapr.Views.SurveyScreenView.extend
  initialize: ->
    _.bindAll(@, 'render')
    @listenTo(@model, 'change:answered', @set_answered_display)
    @
    
  tagName: 'div',

  set_answered_display: (m) ->
    @$('.answered-status').text(m.get('answered'))
    
  events:
    'click #save-response': ->
      # Don't bother doing anything if the survey wasn't answered.
      return if @model.get('answered') == false
      
      qn_response = @collection.map (m) ->
        m.response_data()
        
      url = '/individual_answers'

      d={}
      d['survey_token'] = @model.survey_token
      d['sqn_id'] = @model.get('id')
      d['response_data'] = JSON.stringify({data: qn_response})
      $.post url, d, (d, s, x) ->
        
  render: ->
    data = @model.attributes
    sq_html =  _.template($('#survey-question-template').html())(data)
    @$el.html sq_html
    
    save_button = $('<div>').attr('id', 'save-response').addClass('col-xs-12 clickable').text('Save Response')
    @$el.append save_button

    @
    
  append_idea_template: (idea_or_details_coll) ->
    view_self = @

    @collection = idea_or_details_coll
    @listenTo(idea_or_details_coll, 'answered', (coll) ->
      view_self.model.set('answered', coll.answered)
    )
    
    idea_or_details_coll.sqn_id = @model.get('id')
    qn_type = @model.get('question_type')

    if qn_type == 5 or qn_type == 6
      idea_list_view = new IdeaMapr.Views.PublicDetailsCollectionView
        collection: idea_or_details_coll
    else
      idea_list_view = new IdeaMapr.Views.PublicIdeaListView
        collection: idea_or_details_coll
        
    idea_list_view.question_id = @model.get('id')
    idea_list_view.question_type = qn_type
      
    @$('#idea-list').append(idea_list_view.render().el)
