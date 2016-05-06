IdeaMapr.Views.SurveyNavbarView = Backbone.View.extend
  initialize: ->
    _.bindAll(this, 'render')
    _.bindAll(this, 'run_decorations')
    this.listenTo(this.model, 'survey:selection_changed', this.render)
    this.listenTo(this.collection, 'sync', this.render)
    this.nav_texts =
        0:
          right: 'Begin'
    this.nav_texts[this.model.get('number_of_screens') - 1] =
      right: 'Finish'
    
  events:
    'click #go-right': (evt) ->
      if $(evt.target).hasClass('active')
        this.model.trigger('survey:recrement_question', {direction: 1})
    'click #go-left': (evt) ->
      if $(evt.target).hasClass('active')
        this.model.trigger('survey:recrement_question', {direction: -1})

  nav_text: (section, screen_index) ->
    if this.nav_texts[screen_index]? &&
       this.nav_texts[screen_index][section]?
      return this.nav_texts[screen_index][section]
    else
      switch section
        when "left" then return "Previous"
        when "right" then return "Next"
      
  run_decorations: ->
    this.$('.col-xs-4').removeClass('inactive')
    this.$('#go-left').text(this.nav_text('left', this.model.get('selected_screen')))
    this.$('#go-right').text(this.nav_text('right', this.model.get('selected_screen')))

    if this.model.get('selected_screen') == 0
      this.$('#go-left').addClass('inactive')
      this.$('#go-left').removeClass('active')
      
    if this.model.get('selected_screen') == (this.model.get('number_of_screens') - 1)
      this.$('#go-right').removeClass('active')
      this.$('#go-right').addClass('inactive')

  render: ->
    data =
      current_question_index: this.model.get('selected_screen') + 1
      total_questions: this.model.get('number_of_screens')
      
    this.$el.html(_.template($('#survey-nb-template').html())(data))
    this.run_decorations()
    this
  
