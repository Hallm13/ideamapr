IdeaMapr.Views.AdminSearchQuestionListView = Backbone.View.extend
  initialize: ->
    _.bindAll @, 'render'
    _.bindAll @, 'show'
    @listenTo @model, 'change', @toggle_question_boxes
    @added_count = 0
    @

  events:
    'keyup #question-search': (evt) ->
      @model.set 'query', $(evt.target).val()
    'click .x-box': (evt) ->
      @$el.hide()
      $('.overlay').hide()      
      
  render: ->
    view_self = @

    t = {available_count: (@orig_length - @added_count), added_count: @added_count}
    @$el.html(_.template($('#admin-search-question-list').html())(t))
    @$('#question-search').val(@model.get('query'))

    @collection.each (m) ->
      child_view = new IdeaMapr.Views.AdminSearchQuestionView
        model: m
      e = child_view.render().el
      view_self.$('#unassigned-questions').append e

      if m.get('title').search(view_self.model.get('query')) == -1
        $(e).hide()
    @$el.append @x_box()
    @

  toggle_question_boxes: ->
    view_self = @
    @$('.question-box').each (idx, elt) ->
      if $(elt).find('.title-box').text().search(view_self.model.get('query')) > -1
        $(elt).show()
      else
        $(elt).hide()
        
  show: ->
    @$el.show()
    $('html, body').animate({scrollTop:$('#search-list').offset().top}, 'slow');
    
  x_box: ->
    $('<div>').addClass('x-box').text('X')
