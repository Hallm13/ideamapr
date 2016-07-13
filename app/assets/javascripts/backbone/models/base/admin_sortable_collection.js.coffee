IdeaMapr.Collections.AdminSortableCollection = Backbone.Collection.extend
  initialize: ->
    @listenTo @, 'change:ranked', @rerank_and_sort
    @listenTo @, 'remove', @reset_ranks
    
  comparator: (m) ->
    m.get('component_rank')

  append_rank: (m) ->
    m.set('component_rank', @models.length)
    
  reset_ranks: ->
    start = 0
    _.each(@models, (m) ->
      m.set('component_rank', start)
      start += 1
    )

  rerank_and_sort: (m, new_val) ->
    # One of the models has been moved up or down: new_val == 1 => moved up
    # Return false if we want to avoid re-rendering

    # Avoid infinite loop
    if new_val == 0
      return false
      
    # if the model was removed from the collection, we have to hope some containing view
    # collection knows what to do with it.
    if new_val == -10
      @remove m
      return false
      
    if new_val == 1 and m.get('component_rank') == 0
      return false
    if new_val == -1 and m.get('component_rank') == @models.length - 1
      m.set('ranked', 0)
      return false

    # Can be moved -> change_model is now the possible candidate to be moved as a result
    change_model = @models[0]
    fix_model = null
    _.each(@models, (m) ->
      current_move = m.get('ranked')

      if current_move == 1
        # We want to move it up
        m.set('ranked', 0)
        m.set('component_rank', change_model.get('component_rank'))
        change_model.set('component_rank', change_model.get('component_rank') + 1)
      else if current_move == -1
        m.set('ranked', 0)
        fix_model = m
      else if current_move == 0
        # 1. maybe this will be moved down...
        change_model = m
        
        if fix_model != null
          # or 2. we marked something to be moved down.
          m.set('component_rank', fix_model.get('component_rank'))
          fix_model.set('component_rank', fix_model.get('component_rank') + 1)
          fix_model = null
    )
    @sort()
    null
    
  serialize: ->
    # Create an array that's relevant to being used to save into a SQ or a survey model on the backend

    coll_self = @
    ret = new Array()
    @each (m) ->
      rec =
        component_rank: m.get('component_rank')
                
      if coll_self.hasOwnProperty('survey_token')
        # This is a sorted collection of SQs obtained for a given survey
        _.extend(rec,
          id: m.get('id')
          ordering: m.get('component_rank')
        )
      else if coll_self.question_type == 5 or coll_self.question_type == 6
        rec['text'] = m.get('text')
      else
        _.extend(rec,
          id: m.get('id')
          ordering: m.get('component_rank')
          budget: m.get('cart_amount')
        )
      ret.push rec
      
    ret
