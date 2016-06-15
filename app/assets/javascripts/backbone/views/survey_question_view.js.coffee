IdeaMapr.Views.SurveyQuestionView = Backbone.View.extend
  initialize: ->
    _.bindAll(@, 'render')
    @
    
  tagName: 'div',
  className: 'myhidden row'

  toggle_view: ->
    if @$el.hasClass 'myhidden'
      @$el.removeClass 'myhidden'
    else
      @$el.addClass 'myhidden'
      
  render: ->
    data = @model.attributes
    sq_html =  _.template($('#survey-question-template').html())(data)
    @$el.html sq_html
    
    @
    
  append_idea_template: (idea_or_details_coll) ->
    view_self = @
    
    @listenTo(idea_or_details_coll, 'idea_or_details:received_answer', ->
      view_self.model.set('answered', true)
    )
    
    idea_or_details_coll.sqn_id = @model.get('id')
    idea_list_view = new IdeaMapr.Views.PublicIdeaListView
      collection: idea_or_details_coll
    idea_list_view.question_id = @model.get('id')
    idea_list_view.question_type = @model.get('question_type')
      
    @$('#idea-list').append(idea_list_view.render().el)
