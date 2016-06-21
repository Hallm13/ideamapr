IdeaMapr.Views.AdminSearchIdeaView = Backbone.View.extend
  top_container_class: 'idea-box'
  initialize: ->
    _.bindAll(@, 'render')
    @top_container_selector = '.' + @top_container_class
    @$el.addClass @top_container_class

    @
    
  events:
    'click .square-button': (evt) ->
      @model.set('promoted', 1)
      
  render: ->
    template_id = '#idea-search-template'
    html = _.template($(template_id).html())(@model.attributes)
    @$el.html html
    @
