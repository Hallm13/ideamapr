IdeaMapr.Views.AdminSearchIdeaListView = Backbone.View.extend
  initialize: ->
    _.bindAll(@, 'render')
    @listenTo(@model, 'change', @toggle_idea_boxes)
    @added_count = 0
    @

  events:
    'keyup #idea-search': (evt) ->
      @model.set('query', $(evt.target).val())
      
  render: ->
    viewself = @

    @$el.html(_.template($('#admin-search-idea-list').html())({available_count: (@orig_length - @added_count), added_count: @added_count}))
    @$('#idea-search').val(@model.get('query'))

    @collection.each (m) ->
      child_view = new IdeaMapr.Views.AdminSearchIdeaView
        model: m
      child_view.question_type = viewself.question_type
      e = child_view.render().el
      viewself.$('#unassigned-ideas').append e

      if $(e).find('.title-box').text().search(viewself.model.get('query')) == -1
        $(e).hide()
    
    @

  toggle_idea_boxes: ->
    viewself = @
    @$('.idea-box').each (idx, elt) ->
      if $(elt).find('.title-box').text().search(viewself.model.get('query')) > -1
        $(elt).show()
      else
        $(elt).hide()
        
