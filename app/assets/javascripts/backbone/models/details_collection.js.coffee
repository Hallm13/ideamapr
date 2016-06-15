IdeaMapr.Collections.DetailsCollection = Backbone.Collection.extend
  urlRoot: '/question_details?'
  url: ->
    @urlRoot + 'for_question=' + @question_id
  model: IdeaMapr.Models.DetailComponent
  initialize: ->
    @listenTo(@, 'sync', @assign_ranking_with_dummy)
    @listenTo(@, 'change:is_promoted', @reset_and_sort)
    @listenTo(@, 'change:radio_selected', @unselect_others)

    coll_self = @
    @listenTo(@, 'change:answered', (model) ->
      coll_self.trigger('idea_or_details:received_answer')
    )
    
  unselect_others: (model, options) ->
    # When the user selects one of the radio buttons, the models for the rest should
    # record them as unselected
    console.log 'starting unselect'
    return if model.get('radio_selected') == false
    model.set('radio_selected', false)
    @.each (m) ->
      if m.get('idea_rank') != model.get('idea_rank')
        m.attributes['response_data']['checked'] = false

  reset_and_sort: (model, options) ->
    if model.get('is_promoted') == false
      # Avoid infinite loop
      return
    model.set('is_promoted', false)
    
    if model.get('idea_rank') == 0
      # Top model cannot be promoted; ignore
      return
    swap_old = model.get('idea_rank') - 1
    _.each(@models, (m) ->
      if m.get('idea_rank') == swap_old
        m.set('idea_rank', model.get('idea_rank'))
      else if m.get('idea_rank') == model.get('idea_rank')
        m.set('idea_rank', swap_old)
    )
    @sort()

  comparator: (m) ->
    m.get('idea_rank')
    
  assign_ranking_with_dummy: ->
    # Add dummy models for showing examples
    ranking = 0
    _.each @models, (m) ->
      m.set('idea_rank', ranking)
      ranking += 1

    start_count = @models.length
    range = (x for x in [0..(2-start_count)] by 1)
    for i in range
      m = new IdeaMapr.Models.DetailComponent()
      @add m
    @.trigger('ready_to_render')
    
