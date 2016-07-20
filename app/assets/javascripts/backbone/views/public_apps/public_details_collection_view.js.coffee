IdeaMapr.Views.PublicDetailsCollectionView = Backbone.View.extend
  initialize: ->
    _.bindAll(@, 'render')
    @component_views = []
    @

  unselect_others: (selected_view) ->
    @component_views.forEach (elt, idx) ->
      unless elt.cid == selected_view.cid
        elt.unselect()
    
  render: ->
    t = _.template($('#details-collection-template').html())
    @$el.html(t())
    @$('#add-button').remove()
    
    view_self = @
    @collection.each (model) ->
      component_view = new IdeaMapr.Views.PublicDetailView
        model: model
      component_view.question = view_self.question
      view_self.component_views.push component_view
      view_self.$('#options-list').append(component_view.render().el)
      
    @
