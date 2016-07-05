# Base class for AdminAssignedIdeaListView, PublicIdeaListView which use the sort trigger, and for AdminDetailsCollectionView
# and AdminIdeaCollectionsView which use populate_data() .
# TODO make AdminSearchIdeaListView a child of this? at this point, it's not sortable, so maybe not.

IdeaMapr.Views.IdeaListView = Backbone.View.extend
  tagName: 'div',
  initialize: ->
    _.bindAll(@, 'render')
    @listenTo(@collection, 'sync', @render)
    @listenTo(@collection, 'sort', @render)

  populate_data: ->
    # This triggers the fetches on whichever lists the SQ model for this listing view
    # contains
    @model.trigger_fetches()
