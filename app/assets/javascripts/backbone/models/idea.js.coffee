IdeaMapr.Models.Idea = Backbone.Model.extend
  defaults: ->
    pro: 0
    con: 0
    title: null
    idea_rank: -1
    grant_top: false
    
  urlRoot: '/ideas',

  initialize: ->
    this.on('move-top', this.grant_top)

  increment_note: (type) ->
    if type == 'pro' || type == 'con'
      this.set(type, this.get(type) + 1)

  grant_top: ->
    this.set('grant_top', true)
    this
