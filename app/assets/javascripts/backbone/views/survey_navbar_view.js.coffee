IdeaMapr.Views.SurveyNavbarView = Backbone.View.extend
  initialize: ->
    _.bindAll(this, 'render')
    _.bindAll(this, 'run_decorations')
    this.listenTo(this.collection, 'survey:selection_changed', this.render)
    
  events:
    'click #go-right': (evt) ->
      this.collection.trigger('survey:increment_question')
    'click #go-left': (evt) ->
      this.collection.trigger('survey:decrement_question')
      
  run_decorations: ->
    this.$('.col-xs-4').removeClass('inactive')
    
    if this.collection.selected_question == 0
      this.$('#go-left').addClass('inactive')
    if this.collection.selected_question == (this.collection.models.length - 1)
      this.$('#go-right').addClass('inactive')

  render: ->
    data =
      current_question_index: this.collection.selected_question
      total_questions: this.collection.models.length
      
    this.$el.html(_.template($('#survey-nb-template').html())(data))
    this.run_decorations()
    this
  
