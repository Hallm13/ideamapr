IdeaMapr.Collections.IdeaCollection = Backbone.Collection.extend
  urlRoot: '/ideas',
  url: ->
    this.urlRoot + '/?for_survey=' + this.survey_id
    
  getSurveyIdeas: (id) ->
    this.survey_id = id
    this.fetch()
        
  model: IdeaMapr.Models.Idea,
  
  getById: ->
    this.fetch
      success: (coll, resp, opt) ->
        coll.set resp['data']

