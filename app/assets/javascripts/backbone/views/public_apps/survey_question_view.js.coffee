IdeaMapr.Views.SurveyQuestionView = IdeaMapr.Views.SurveyScreenView.extend
  initialize: ->
    _.bindAll(@, 'render')
    @
    
  tagName: 'div',
    
  render: ->
    sq_html =  _.template($('#survey-question-screen-template').html())(@model.attributes)
    @$el.html sq_html

    # HAML::Engine won't let id attribute be html_safe
    @$el.attr 'id', 'question_screen_' + @model.get('id')

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
      if question_type == 1
        # Ranking type should not show ranks to start with
        idea_list_view.show_ranks = false
        
    idea_list_view.question = @model      
    @$('#idea-list').append(idea_list_view.render().el)
