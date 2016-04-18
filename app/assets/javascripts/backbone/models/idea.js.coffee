IdeaMapr.Models.Idea = Backbone.Model.extend
  defaults: ->
    pro: 0
    con: 0
    title: null
  urlRoot: '/ideas',

  increment_note: (type) ->
    if type == 'pro' || type == 'con'
      this.set(type, this.get(type) + 1)
