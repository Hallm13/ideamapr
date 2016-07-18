IdeaMapr.Collections.DetailsCollection = IdeaMapr.Collections.AdminSortableCollection.extend
  urlRoot: '/question_details?'
  url: ->
    @urlRoot + 'for_survey_question=' + @survey_question_id
  model: IdeaMapr.Models.DetailComponent

  comparator: (m) ->
    m.get('component_rank')
    
  initialize: ->
    # Super (in Backbone) - well, basically we explicitly call what we know is our
    # parent prototype.
    
    _.bindAll(@, 'append_model') 
    IdeaMapr.Collections.AdminSortableCollection.prototype.initialize.call @

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
      if m.get('component_rank') != model.get('component_rank')
        m.attributes['response_data']['checked'] = false
        
  append_model: (m) ->
    if typeof this.models == 'undefined'
      m.set('component_rank', 0)
    else
      m.set('component_rank', @models.length)
    @add m
