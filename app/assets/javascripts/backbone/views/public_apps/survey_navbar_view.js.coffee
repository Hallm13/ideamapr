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
        @model.post_response_to_server()
        @model.trigger('survey:recrement_question', {model: @model, direction: 1})
    'click #go-left': (evt) ->
      if $(evt.target).hasClass('active')
        @model.trigger('survey:recrement_question', {model: @model, direction: -1})
    'click #current-question': (evt) ->
      @$('#other-sections').toggle()
      @toggle_bottom_border $(evt.target)
    'click #other-sections .clickable': (evt) ->
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
    curr_qn = @model.get('current_screen')
    total_screens = @model.get('number_of_screens')
    hidden_row = @$('#other-sections')
    range = (i for i in [0..total_screens-1])
    view_self = @
    for idx in range
      unless idx == curr_qn
        t = $(_.template($('#public-navbar-dropdown-element').html())(idx: idx))
        t.text view_self.dropdown_text(idx)
        if view_self.model.answered[idx]
          t.addClass 'answered'
        
        hidden_row.append t

  dropdown_text: (idx) ->
    switch idx
      when 0
        'Introduction'
      when @collection.length + 1
        'Summary'
      else
        @summarized(@collection.models[idx - 1].get('title'))

  summarized: (str) ->
    words = str.split(/\s+/)
    if words.length < 4
      str
    else
      words.slice(0, 4).join(' ') + ' ...'

  survey_current_title: ->
    curr_screen = @model.get('current_screen')
    switch curr_screen
      when 0
        total_qns = @model.get('number_of_screens') - 2
        total_qns + ' questions'
      else
        @dropdown_text(curr_screen)
      
  render: ->
    data =
      # this is what is displayed.
      current_question_index: @model.get('current_screen')
      summarized_qn_title: @survey_current_title()
      
    @$el.html(_.template($('#survey-nb-template').html())(data))
    @run_decorations()
    @make_dropdown()
    
    @
  
  toggle_bottom_border: ($elt) ->
    if $elt.hasClass('thin-bottom')
      $elt.removeClass 'thin-bottom'
    else
      $elt.addClass 'thin-bottom'
