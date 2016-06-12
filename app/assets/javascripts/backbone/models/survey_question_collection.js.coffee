IdeaMapr.Collections.SurveyQuestionCollection = Backbone.Collection.extend
  reset_ranks: ->
    start = 1
    _.each(@models, (m) ->
      m.set('question_rank', start)
      start += 1
    )  
  append_rank: (m) ->
    m.set('question_rank', @models.length)
    
  rerank_and_sort: (m, new_val) ->
    # One of the models has been moved up or down: new_val == 1 => moved up
    if new_val == 1 and m.get('question_rank') == 1
      return
    if new_val == -1 and m.get('question_rank') == @models.length + 1
      return

    # Can be moved
    change_model = @models[0]
    fix_model = null
    _.each(@models, (m) ->
      current_rank = m.get('ranked')
      if current_rank == 1
        m.set('ranked', 0)
        m.set('question_rank', change_model.get('question_rank'))
        change_model.set('question_rank', change_model.get('question_rank') + 1)
      else if current_rank == -1
        m.set('ranked', 0)
        fix_model = m
      else if current_rank == 0
        change_model = m
        if fix_model != null
          m.set('question_rank', fix_model.get('question_rank'))
          fix_model.set('question_rank', change_model.get('question_rank') + 1)
          fix_model = null          
    )
    @.sort()
    @
    
  urlRoot: '/survey_questions',
  url: ->
    if typeof @survey_token == 'undefined'
      @urlRoot
    else
      @urlRoot + '?for_survey=' + @survey_token

  comparator: (m) ->
    m.get('question_rank')
        
  model: IdeaMapr.Models.SurveyQuestion

