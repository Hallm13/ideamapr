IdeaMapr.Models.IdeaListOfLists = Backbone.Model.extend
  urlRoot: '/public_info/double_bundle',
  url: ->
    if typeof @survey_token != 'undefined'
      @urlRoot + '?for_survey=' + @survey_token
    else
      @urlRoot
    
