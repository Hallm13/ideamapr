IdeaMapr.Collections.DetailsCollection = IdeaMapr.Collections.AdminSortableCollection.extend
  urlRoot: '/question_details?'
  url: ->
    @urlRoot + 'for_survey_question=' + @survey_question_id
  model: IdeaMapr.Models.DetailComponent

  initialize: ->
    # Super (in Backbone) - well, basically we explicitly call what we know is our
    # parent prototype.
    IdeaMapr.Collections.AdminSortableCollection.prototype.initialize.call @
    
    @listenTo(@, 'sync', @assign_ranking_with_dummy)

    coll_self = @
    @listenTo @, 'change:response_enter_count', (model) ->
      if model.attributes['response_data'].hasOwnProperty('checked') &&\
         model.attributes['response_data']['checked'] == true
        # This only happens if the detail model is a radio button
        coll_self.unselect_others(model)
    
    @listenTo @, 'change:answered', (model) ->
      coll_self.answered = model.get('answered')
      coll_self.trigger 'answered', coll_self
    
  unselect_others: (model, options) ->
    # When the user selects one of the radio buttons, the models for the rest should
    # record them as unselected
    return if model.get('checked') == false

    @.each (m) ->
      if m.get('idea_rank') != model.get('idea_rank')
        m.attributes['response_data']['checked'] = false

  comparator: (m) ->
    m.get('idea_rank')
    
  assign_ranking_with_dummy: ->
    # Add dummy models for showing examples
    ranking = @models.length
    if ranking < 3
      range = (x for x in [0..(2-ranking)] by 1)
      for i in range
        m = new IdeaMapr.Models.DetailComponent()
        m.set('idea_rank', ranking)
        ranking += 1
        @add m

    # This will trigger the render, even though the list is already sorted
    @sort()
    
