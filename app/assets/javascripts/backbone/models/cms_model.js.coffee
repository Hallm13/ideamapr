IdeaMapr.Models.CmsModel = Backbone.Model.extend
  urlRoot: '/ajax_api?payload=cms/get/',
  getById: ->
    this.fetch
      success: (m, resp, opt) ->
        m.set(resp['data'])

IdeaMapr.Models.CmsList = Backbone.Collection.extend
  urlRoot: '/ajax_api?payload=cms/get/',
  url: ->
    return this.urlRoot + this.search_filter
  model: IdeaMapr.Models.CmsModel,
  getById: ->
    if this.models.length == 0
      this.fetch
        success: (coll, resp, opt) ->
          coll.set resp['data']
