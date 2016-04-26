IdeaMapr.Collections.SurveyQuestionCollection = Backbone.Collection.extend
  urlRoot: '/survey_questions?for_survey='
  url: ->
    this.urlRoot + this.survey_id
    
  model: IdeaMapr.Models.SurveyQuestion,

  getQuestions: (survey_id) ->
    this.survey_id = survey_id
    console.log('Fetching for survey ' + this.survey_id)
    this.fetch()
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
