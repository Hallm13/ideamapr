# Display ideas in survey question editing
# The model for this view is the SQ it is in.

IdeaMapr.Views.AdminIdeaCollectionsView = IdeaMapr.Views.IdeaListView.extend
  initialize: ->
    _.bindAll(@, 'render')

    @assigned_collection = new IdeaMapr.Collections.IdeaCollection()
    # Let the SQ model know where the selected ideas are.
    @model.assigned_ideas = @assigned_collection
    
    @selected_view = new IdeaMapr.Views.AdminAssignedIdeaListView
      el: $('#selected-list')
      collection: @assigned_collection

    @to_search_collection = new IdeaMapr.Collections.IdeaCollection()
    @search_view = new IdeaMapr.Views.AdminSearchIdeaListView
      el: $('#search-box')
      collection: @to_search_collection
      model: new IdeaMapr.Models.SearchQueryModel()

    @listenTo(@assigned_collection, 'remove', @redistribute)
    @listenTo(@to_search_collection, 'remove', @redistribute)

    # the distribute will also render this view.    
    @listenToOnce(@model.idea_list, 'sync', @distribute)
    @

  render: ->
    set_type = @model.get('question_type')
    
    @selected_view.question_type = set_type
    @search_view.question_type = set_type
      
    @selected_view.render()
    @search_view.render()
