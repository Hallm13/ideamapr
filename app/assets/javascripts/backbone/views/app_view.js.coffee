IdeaMapr.Views.AppView = Backbone.View.extend
  initialize: ->
    _.bindAll(this, 'render')
    this.listenTo(this.collection, "survey_questions:clone_done", this.render)

  render: ->
    # App contains many questions, based on the sqn collection it has
    view_self = this
    this.collection.each (question_object) ->
      sq_view = new IdeaMapr.Views.SurveyQuestionView
        model: question_object
      view_self.$el.append(sq_view.render().el)

    this
    
  append_qn_template: (view) ->
    this.$el.append view.render().el

  events:
    'click #change-step': (evt) ->
      target_step = $(evt.target).data('target-step')
      this.model.getStep target_step
