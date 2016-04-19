IdeaMapr.Collections.IdeaCollection = Backbone.Collection.extend
  initialize:->
    this.on('change:grant_top', this.reset_and_sort)

  reset_and_sort: (model) ->
    # If the cb is fired when the top flag is taken away
    # don't continue.
    if model.get('grant_top') == false
      return
      
    save_id = model.get('id')
    this.each (in_m) ->
      if in_m.get('id') == save_id
        in_m.set('idea_rank', -10)
      else
        in_m.set('idea_rank', -1)
        in_m.set('grant_top', false)
    this.sort()
    
  urlRoot: '/ideas',
  url: ->
    this.urlRoot + '/?for_survey=' + this.survey_id

  comparator: (m) ->
    m.get('idea_rank')
        
  getSurveyIdeas: (id) ->
    this.survey_id = id
    this.fetch()
        
  model: IdeaMapr.Models.Idea,
  
  getById: ->
    this.fetch
      success: (coll, resp, opt) ->
        coll.set resp['data']

