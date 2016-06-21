IdeaMapr.Collections.IdeaCollection = Backbone.Collection.extend
  urlRoot: '/ideas',
  url: ->
    if typeof @survey_token != 'undefined'
      @urlRoot + '?for_survey=' + @survey_token
    else
      @urlRoot + '?for_survey_question=' + @survey_question_id

  model: IdeaMapr.Models.Idea
  initialize: ->
    coll_self = @
    @listenTo(@, 'change:answered', (model) ->
      coll_self.answered = model.get('answered')
      coll_self.trigger 'answered', coll_self
    )
    
  reset_ranks: ->
    start = 1
    _.each(@models, (m) ->
      m.set('idea_rank', start)
      start += 1
    )
  append_rank: (m) ->
    m.set('idea_rank', @models.length)
    
  rerank_and_sort: (m, new_val) ->
    # One of the models has been moved up or down: new_val == 1 => moved up
    if new_val == 1 and m.get('idea_rank') == 1
      return
    if new_val == -1 and m.get('idea_rank') == @models.length + 1
      return

    # Can be moved
    change_model = @models[0]
    fix_model = null
    _.each(@models, (m) ->
      current_rank = m.get('ranked')
      if current_rank == 1
        m.set('ranked', 0)
        m.set('idea_rank', change_model.get('idea_rank'))
        change_model.set('idea_rank', change_model.get('idea_rank') + 1)
      else if current_rank == -1
        m.set('ranked', 0)
        fix_model = m
      else if current_rank == 0
        change_model = m
        if fix_model != null
          m.set('idea_rank', fix_model.get('idea_rank'))
          fix_model.set('idea_rank', change_model.get('idea_rank') + 1)
          fix_model = null
    )
    @.sort()
    @
    
  comparator: (m) ->
    m.get('idea_rank')
