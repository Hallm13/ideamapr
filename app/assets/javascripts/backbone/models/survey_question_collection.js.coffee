IdeaMapr.Collections.SurveyQuestionCollection = IdeaMapr.Collections.AdminSortableCollection.extend
  initialize: ->
    # Super (in Backbone) - well, basically we explicitly call what we know is our
    # parent prototype.
    IdeaMapr.Collections.AdminSortableCollection.prototype.initialize.call @

    coll_self = @
    @
        
  urlRoot: '/survey_questions',
  url: ->
    if typeof @survey_token == 'undefined'
      @urlRoot
    else
      @urlRoot + '?for_survey=' + @survey_token

  model: IdeaMapr.Models.SurveyQuestion
