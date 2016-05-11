IdeaMapr.Collections.ProConIdeaCollection = IdeaMapr.Collections.IdeaCollection.extend
  post_initialize: ->
    model_self = this
    _.each(this.models, (m, idx) ->
      m.has_procon = false
    )
    return
    
  model: IdeaMapr.Models.Idea,
