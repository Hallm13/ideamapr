IdeaMapr.Models.Idea = Backbone.Model.extend
  defaults: ->
    pro: 0
    con: 0
  
  urlRoot: '/ideas',
  url: ->
    this.urlRoot + '/?for_survey=' + this.survey_id
  getSurveyIdea: (id) ->
    this.survey_id = id
    this.fetch
      success: (m, resp, opt) ->
        m.set resp[0]
    
  increment_note: (type) ->
    if type == 'pro' || type == 'con'
      this.set(type, this.get(type) + 1)
