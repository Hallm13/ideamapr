IdeaMapr.Views.SurveyQuestionView = IdeaMapr.Views.SurveyScreenView.extend
  initialize: ->
    _.bindAll(@, 'render')
    @listenTo(@model, 'change:answered', @set_answered_display)
    @
    
  tagName: 'div',

  set_answered_display: (m) ->
    @$('.answered-status').text(m.get('answered'))
    
  render: ->
    data = @model.attributes
    data = _.extend(data, {question_screen_id: 'question_screen_' + @model.get('id')})
    sq_html =  _.template($('#survey-question-screen-template').html())(data)
    @$el.html sq_html

    @
    
  append_idea_template: (idea_or_details_coll) ->
    view_self = @
    question_type = @model.get('question_type')

    if question_type == 5 or question_type == 6
      idea_list_view = new IdeaMapr.Views.PublicDetailsCollectionView
        model: @model
        collection: idea_or_details_coll
    else
      idea_list_view = new IdeaMapr.Views.PublicIdeaListView
        model: @model
        collection: idea_or_details_coll
      if question_type == 3
        idea_or_details_coll.budget = @model.get('budget')
        
    idea_list_view.question_id = @model.get('id')
    idea_list_view.question_type = question_type
      
    @$('#idea-list').append(idea_list_view.render().el)
