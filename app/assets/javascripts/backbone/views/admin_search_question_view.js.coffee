IdeaMapr.Views.AdminSearchQuestionView = Backbone.View.extend
  className: 'col-xs-12 question-box',
  tagName: 'div',
  
  initialize: ->
    _.bindAll(@, 'render')
    @
    
  events:
    'click .square-button': (evt) ->
      @model.set('promoted', 1)
      
  render: ->
    template_id = '#survey-question-search-template'
    html = _.template($(template_id).html())(@model.attributes)
    @$el.html html
    @
