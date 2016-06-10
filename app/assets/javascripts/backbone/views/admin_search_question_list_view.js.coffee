IdeaMapr.Views.AdminSearchQuestionListView = Backbone.View.extend
  initialize: ->
    _.bindAll(@, 'render')
    @listenTo(@model, 'change', @toggle_question_boxes)
    @added_count = 0
    @

  events:
    'keyup #question-search': (evt) ->
      @model.set('query', $(evt.target).val())
      
  render: ->
    viewself = @

    t = {available_count: (@orig_length - @added_count), added_count: @added_count}
    @$el.html(_.template($('#admin-search-question-list').html())(t))
    @$('#question-search').val(@model.get('query'))

    @collection.each (m) ->
      child_view = new IdeaMapr.Views.AdminSearchQuestionView
        model: m
      e = child_view.render().el
      viewself.$('#unassigned-questions').append e

      if m.get('title').search(viewself.model.get('query')) == -1
        $(e).hide()
    @

  toggle_question_boxes: ->
    viewself = @
    @$('.question-box').each (idx, elt) ->
      if $(elt).find('.title-box').text().search(viewself.model.get('query')) > -1
        $(elt).show()
      else
        $(elt).hide()
        
