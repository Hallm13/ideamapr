IdeaMapr.Views.SurveyNavbarView = Backbone.View.extend
  initialize: ->
    _.bindAll(@, 'render')
    _.bindAll(@, 'run_decorations')
    @listenTo(@model, 'survey:selection_changed', @render)
    @listenTo(@collection, 'sync', @render)
    @nav_texts =
        0:
          right: 'Begin'
    @nav_texts[@model.get('number_of_screens') - 1] =
      right: 'Finish'
    
  events:
    'click #go-right': (evt) ->
      if $(evt.target).hasClass('active')
        @model.trigger('survey:recrement_question', {direction: 1})
    'click #go-left': (evt) ->
      if $(evt.target).hasClass('active')
        @model.trigger('survey:recrement_question', {direction: -1})

  nav_text: (section, screen_index) ->
    if @nav_texts[screen_index]? &&
       @nav_texts[screen_index][section]?
      return @nav_texts[screen_index][section]
    else
      switch section
        when "left" then return "Previous"
        when "right" then return "Next"
      
  run_decorations: ->
    # make everything active (?)
    @$('.col-xs-4').removeClass('inactive')
    
    @$('#go-left').text(@nav_text('left', @model.get('current_question')))
    @$('#go-right').text(@nav_text('right', @model.get('current_question')))

    if @model.get('current_question') == 0
      @$('#go-left').addClass('inactive')
      @$('#go-left').removeClass('active')
      
    if @model.get('current_question') == (@model.get('number_of_screens') - 1)
      @$('#go-right').removeClass('active')
      @$('#go-right').addClass('inactive')

  render: ->
    data =
      current_question_index: @model.get('current_question') + 1
      total_screens: @model.get('number_of_screens')
      
    @$el.html(_.template($('#survey-nb-template').html())(data))
    @run_decorations()
    @
  
