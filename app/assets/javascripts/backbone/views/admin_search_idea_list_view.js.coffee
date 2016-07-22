IdeaMapr.Views.AdminSearchIdeaListView = Backbone.View.extend
  initialize: ->
    _.bindAll @, 'render'
    _.bindAll @, 'show'
    
    @listenTo @model, 'change', @toggle_idea_boxes
    @added_count = 0
    @

  events:
    'keyup #idea-search': (evt) ->
      @model.set('query', $(evt.target).val())
    'click .x-box': (evt) ->
      @$el.hide()
      $('.overlay').hide()      

  show: ->
    @$el.show()
    
  x_box: ->
    $('<div>').addClass('x-box').text('X')
      
  render: ->
    view_self = @

    @$el.html(_.template($('#admin-search-idea-list').html())({available_count: (@orig_length - @added_count), added_count: @added_count}))
    @$('#idea-search').val(@model.get('query'))

    @collection.each (m) ->
      child_view = new IdeaMapr.Views.AdminSearchIdeaView
        model: m
      child_view.question_type = view_self.question_type
      e = child_view.render().el
      view_self.$('#unassigned-ideas').append e

      if $(e).find('.title-box').text().search(view_self.model.get('query')) == -1
        $(e).hide()
    
    @$el.append @x_box()
    @

  toggle_idea_boxes: ->
    view_self = @
    @$('.idea-box').each (idx, elt) ->
      if $(elt).find('.title-box').text().search(view_self.model.get('query')) > -1
        $(elt).show()
      else
        $(elt).hide()
  
  show: ->
    @$el.show()
    $('html, body').animate({scrollTop:$('#search-list').offset().top}, 'slow');
    
  x_box: ->
    $('<div>').addClass('x-box').text('X')
