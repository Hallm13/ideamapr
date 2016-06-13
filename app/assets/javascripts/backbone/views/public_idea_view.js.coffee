IdeaMapr.Views.PublicIdeaView = Backbone.View.extend
  className: 'col-xs-12 idea-box',
  tagName: 'div',
     
  initialize: ->
    _.bindAll(@, 'render')
    @

  render: ->
    template_id = '#type-' + @question_type + '-public-template'
    html = _.template($(template_id).html())(@model.attributes)
    @$el.html html
    
    @
