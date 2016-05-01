IdeaMapr.Views.AppView = Backbone.View.extend
  initialize: ->
    _.bindAll(this, 'render')
    this.listenTo(this.collection, "sync", this.render)
    this.listenTo(this.collection, "survey:selection_changed", this.change_hidden_class)

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
        
  change_hidden_class: (options) ->
    new_selection = this.collection.selected_question
    if options.direction == 1
      this.question_views[(this.collection.models.length + new_selection - 1) % this.collection.models.length].toggle_view()
    else
      this.question_views[(new_selection + 1) % this.collection.models.length].toggle_view()
    this.question_views[new_selection].toggle_view()

  render: ->
    # App contains many questions, based on the sqn collection it has
    view_self = this

    view_self.question_views = new Array
    navbar_view = new IdeaMapr.Views.SurveyNavbarView
      collection: this.collection
    
    this.$('#survey-navbar').append(navbar_view.render().el)
    
    this.collection.each (question_object, idx) ->
      sq_view = new IdeaMapr.Views.SurveyQuestionView
        model: question_object

      view_self.question_views.push sq_view
      if idx == view_self.collection.selected_question
        sq_view.is_shown = true
      view_self.$('#sq-list').append(sq_view.render().el)

    this
    
  append_qn_template: (view) ->
    this.$el.append view.render().el

