IdeaMapr.Views.SurveyNavbarView = Backbone.View.extend
  className: 'row survey-nb-row'
  initialize: ->
    _.bindAll(@, 'render')
    _.bindAll(@, 'run_decorations')
    @listenTo(@model, 'survey:selection_changed', @render)
    @listenTo(@model, 'survey:done', ->
      @$el.detach()
    )
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
    'click #current-question': (evt) ->
      @$('#other-sections').toggle()
    'click #other-sections .col-xs-4': (evt) ->
      @model.trigger('survey:recrement_question', {move_to: $(evt.target).data('question-index')})
      
  nav_text: (section, screen_index) ->
    if @nav_texts.hasOwnProperty(screen_index) &&
       @nav_texts[screen_index].hasOwnProperty(section)
      return @nav_texts[screen_index][section]
    else
      switch section
        when "left"
          if screen_index == 0
            return ''
          else
            return 'Previous'  
        when "right" then return "Next"
      
  run_decorations: ->
    # make everything active (?)
    @$('.col-xs-4').removeClass('inactive')
    
    @$('#go-left').text(@nav_text('left', @model.get('current_screen')))
    @$('#go-right').text(@nav_text('right', @model.get('current_screen')))

    if @model.get('current_screen') == 0
      @$('#go-left').addClass('inactive')
      @$('#go-left').removeClass('active')
      
    if @model.get('current_screen') == (@model.get('number_of_screens') - 1)
      @$('#go-right').addClass 'theme-red'
      
  make_dropdown: ->
    curr_qn = @model.get('current_screen') + 1
    total_screens = @model.get('number_of_screens')
    hidden_row = @$('#other-sections')
    range = (i for i in [1..total_screens])
    for idx in range
      unless idx == curr_qn
        t = $('<div>').addClass('col-xs-offset-4 col-xs-4 clickable').attr('data-question-index', idx)
        t.text(idx + " of " + total_screens)
        hidden_row.append t
        
  render: ->
    data =
      current_question_index: @model.get('current_screen') + 1
      total_screens: @model.get('number_of_screens')
      
    @$el.html(_.template($('#survey-nb-template').html())(data))
    @run_decorations()
    @make_dropdown()
    
    @
  
