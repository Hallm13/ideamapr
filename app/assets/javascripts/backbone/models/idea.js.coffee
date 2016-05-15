IdeaMapr.Models.Idea = Backbone.Model.extend
  defaults: ->
    pro: 0
    con: 0
    title: null
    promoted: 0
    ranked: 0
    index: 0
    
  urlRoot: '/ideas',

  initialize: ->
    this.on('move-top', this.grant_top)

  make_example: ->
    @set('title', 'Example Idea')
    @set('description', 'Add ideas like this one by clicking + below.')
    
  increment_note: (type) ->
    if type == 'pro' || type == 'con'
      this.set(type, this.get(type) + 1)

  getResponseData: ->
    if this.qn_type == 0 # pro/con
      obj =
        pro: this.get('pro')
        con: this.get('con')
    else if this.qn_type == 1 # ranking
      obj =
        rank: this.get('idea_rank')

    obj['idea_id'] = this.get('id')
    obj
    
  shown_rank: ->
    if this.get('idea_rank') < 0
      return ''
    else
      return this.get('idea_rank')
