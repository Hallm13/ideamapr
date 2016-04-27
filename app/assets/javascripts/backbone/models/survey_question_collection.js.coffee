IdeaMapr.Collections.SurveyQuestionCollection = Backbone.Collection.extend
  initialize: ->
    this.listenTo(this, 'survey:increment_question', this.increment_selection)
    this.listenTo(this, 'survey:decrement_question', this.decrement_selection)

  increment_selection: ->
    this.selected_question = (this.selected_question + 1) % this.models.length
    this.trigger 'survey:selection_changed', {direction: 1}
  decrement_selection: ->
    this.selected_question = (this.selected_question - 1 + this.models.length) % this.models.length
    this.trigger 'survey:selection_changed', {direction: -1}
    
  urlRoot: '/survey_questions?for_survey='
  url: ->
    this.urlRoot + this.survey_id
    
  model: IdeaMapr.Models.SurveyQuestion,

  getQuestions: (survey_id) ->
    this.survey_id = survey_id
    this.fetch()

    this.selected_question = 0
    this

  clone: (coll, options) ->
    # for each question in the collection, clone the list in so that it can be manipulated individually
    # for that question.

    this.each (qn) ->
      qn.setIdeaList coll
    this.trigger 'survey_questions:clone_done'
    this
    
  defaults:
    step: 1
