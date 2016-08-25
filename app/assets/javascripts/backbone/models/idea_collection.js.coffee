IdeaMapr.Collections.IdeaCollection = IdeaMapr.Collections.AdminSortableCollection.extend
  urlRoot: '/ideas',
  url: ->
    if typeof @survey_token != 'undefined'
      @urlRoot + '?for_survey=' + @survey_token
    else if typeof @survey_question_id != 'undefined'
      @urlRoot + '?for_survey_question=' + @survey_question_id
    else
      # We are using this also for the ideas/index page now.
      @urlRoot

  model: IdeaMapr.Models.Idea
  
  initialize: ->
    # Super (in Backbone) - well, basically we explicitly call what we know is our
    # parent prototype.
    IdeaMapr.Collections.AdminSortableCollection.prototype.initialize.call @
    
    coll_self = @
    @cart_total_spend = 0
    
    @listenTo @, 'change:answered', @set_answered
    @listenTo @, 'change:ranked', @set_answered
    
  accept_cart_item: (amt) ->
    # Does the cart budget have the money?
    if @cart_total_spend + amt > @budget
      return false
    else
      return true

  set_answered: (m, v, opts) ->
    @answered = m.get('answered')
    @trigger 'answered', @

  remove_new_idea: (id) ->
    @models.splice id, 1
    @trigger 'sort'

  edit_new_idea: (id, type, text) ->
    @models[id].set type, text
    if type == 'description'
      @models[id].set_summary()
      
    @trigger 'sort'
    
