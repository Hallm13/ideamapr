IdeaMapr.Collections.IdeaCollection = Backbone.Collection.extend
  urlRoot: '/ideas',
  url: ->
    return this.urlRoot + this.search_filter
  model: IdeaMapr.Models.Idea,
  getById: ->
    this.fetch
      success: (coll, resp, opt) ->
        coll.set resp['data']

