IdeaMapr.Views.ComponentView = IdeaMapr.Views.SurveyQuestionIdeaEditView.extend
  className: 'col-xs-12 details-component'
  
  initialize: ->
    _.bindAll(@, 'render')
  events:      
    'blur .editable-text': (evt) ->
      txt = $(evt.target).text()
      @model.set_edited_state(txt.trim())
      this
      
  render: ->
    t = _.template($('#type-' + @question_type + '-public-template').html())
    
    @$el.html(t(@model.attributes))

    if @model.get('is_edited')
      @$el.find('.editable-text').addClass 'edited'

    this
