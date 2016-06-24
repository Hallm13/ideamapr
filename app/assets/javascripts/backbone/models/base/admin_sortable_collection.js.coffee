IdeaMapr.Collections.AdminSortableCollection = Backbone.Collection.extend
  rerank_and_sort: (m, new_val) ->
    # One of the models has been moved up or down: new_val == 1 => moved up
    # Return false if we want to avoid re-rendering

    if new_val == 1 and m.get('idea_rank') == 1
      return false
    if new_val == -1 and m.get('idea_rank') == @models.length - 1
      return false

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

    # Okay, we need to re-render
    true
