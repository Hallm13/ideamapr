IdeaMapr.Views.SurveyPublicView = Backbone.View.extend
  initialize: ->
    _.bindAll(this, 'render')
    this.listenTo(this, "questions_set", this.render)
    this.listenTo(this.collection, "sync", this.set_questions)
    this.listenTo(this.model, "survey:selection_changed", this.change_hidden_class)
    this.screens =
      0: '#welcome-screen'
      
    this

  handle_post: (obj) ->
    $.ajax
      type: 'PUT'
      url: '/survey_responses/0'
      contentType: 'application/json'
      data: JSON.stringify(obj)
      success: (d, s, x) ->
        a = 1+2
        window.location.href = '/survey/thank_you'        
        # what is this
      
  events:
    'click #save-response': (evt) ->
      obj =
        responses: this.collection.map (elt, idx) ->
          elt.getResponseData()

      sid = $('#survey_id').data('survey-id')
      obj['survey_id'] = sid
      obj['cookie_key'] = $('#cookie_key').val()
      this.handle_post(obj)

  handle_toggle: (tgt) ->
    if typeof(tgt) == 'string'
      $(tgt).toggle()
    else
      tgt.toggle_view()
      
  change_hidden_class: ->
    hide_target =  this.screens[this.model.get('previous_selection')]
    show_target =  this.screens[this.model.get('selected_screen')]
    this.handle_toggle hide_target
    this.handle_toggle show_target
    this

  render: ->
    # App contains many questions, based on the sqn collection it has
    # Render is triggered after all the survey question screens have been initialized
    
    view_self = this
    navbar_view = new IdeaMapr.Views.SurveyNavbarView
      collection: this.collection
      model: this.model
      
    this.$('#survey-navbar').append(navbar_view.render().el)

    intro_html = _.template($('#survey-intro-template').html())(this.model.attributes)
    this.$('#survey-intro').html intro_html
    thankyou_html = _.template($('#survey-thankyou-template').html())(this.model.attributes)
    this.$('#survey-thankyou').html thankyou_html
    
    this

  set_questions: ->
    # A different question view is created and appended
    # To the public survey, for each type of question retrieved
    
    view_self = this
    this.collection.each (question_object, idx) ->
      switch question_object.get('question_type')
        when 0  # Procon
          sq_view = new IdeaMapr.Views.SurveyQuestionView
            model: question_object
        when 1 # Ranking
          c = new IdeaMapr.Collections.RankedIdeaCollection(question_object.attributes.ideas)
          c.post_initialize()
          sq_view = new IdeaMapr.Views.SQRankingView
            model: question_object
            collection: c

      # the first screen is the intro screen - the rest are questions
      view_self.screens[1 + idx] = sq_view
      view_self.question_count = 1 +idx
      view_self.$('#sq-list').append(sq_view.render().el)
      
    this.screens[1 + this.question_count] = '#thankyou-screen'
    this.trigger 'questions_set'
    
  append_qn_template: (view) ->
    this.$el.append view.render().el

