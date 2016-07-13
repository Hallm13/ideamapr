IdeaMapr.Collections.IdeaCollection = IdeaMapr.Collections.AdminSortableCollection.extend
  urlRoot: '/ideas',
  url: ->
    if typeof @survey_token != 'undefined'
      @urlRoot + '?for_survey=' + @survey_token
    else
      @urlRoot + '?for_survey_question=' + @survey_question_id

  model: IdeaMapr.Models.Idea
  
  initialize: ->
    # Super (in Backbone) - well, basically we explicitly call what we know is our
    # parent prototype.
    IdeaMapr.Collections.AdminSortableCollection.prototype.initialize.call @
    
    coll_self = @
    @cart_total_spend = 0
    
    @listenTo(@, 'change:answered', (model) ->
      coll_self.answered = model.get('answered')
      coll_self.trigger 'answered', coll_self
    )
    
  accept_cart_item: (amt) ->
    # Does the cart budget have the money?
    if @cart_total_spend + amt > @budget
      return false
    else
      return true
