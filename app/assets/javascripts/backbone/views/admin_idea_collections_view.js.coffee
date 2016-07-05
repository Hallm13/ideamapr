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
    @selected_view.question_type = @model.get('question_type')
    
    @to_search_collection = new IdeaMapr.Collections.IdeaCollection()
    @search_view = new IdeaMapr.Views.AdminSearchIdeaListView
      el: $('#search-box')
      collection: @to_search_collection
      model: new IdeaMapr.Models.SearchQueryModel()
    @search_view.question_type = @model.get('question_type')
      
    @listenTo(@assigned_collection, 'remove', @redistribute)
    @listenTo(@to_search_collection, 'remove', @redistribute)
    
    @listenToOnce(@model.idea_list, 'sync', @distribute)
    @

  redistribute: (m) ->
    # Move the model into or out of the assigned idea list, and re-distribute ranks
    m.set('ranked', 0)
    if m.get('is_assigned') == false
      m.set 'is_assigned', true      
      m.set 'idea_rank', @assigned_collection.models.length
      @assigned_collection.add m
      if @selected_view.example_count > 0
        @selected_view.example_count -= 1
      
      @search_view.added_count += 1
    else
      # It came from the assigned list
      @to_search_collection.add m
      m.set 'is_assigned', false
      @assigned_collection.reset_ranks()
      
      @selected_view.example_count += 1
      @search_view.added_count -= 1

    @render()
    
  distribute: (opts) ->
    # Now I have the ideas, they have to be assigned to the two avlbl views

    # For testing
    if !(opts.hasOwnProperty('render'))
      opts.render = true
      
    viewself = @
    assigned_total = 0
    avlbl_count = 0
    
    _.each(@model.idea_list.models, (m) ->
      if m.get('is_assigned') == true
        viewself.selected_view.collection.add new IdeaMapr.Models.Idea(m.attributes),
          sort: false
        assigned_total += 1
      else
        viewself.search_view.collection.add new IdeaMapr.Models.Idea(m.attributes),
          sort: false
        avlbl_count += 1
    )
    @search_view.orig_length = avlbl_count
    
    # Set a count for how many example ideas to show, up to a max of 3
    @selected_view.example_count = 3 - assigned_total
    @render()
    
  render: ->
    @selected_view.render()
    @search_view.render()
    
  serialize_models: ->
    arr = new Array()
    _.each @assigned_collection.models, (m) ->
      arr.push m

    resp =
      question_type: @question_type
      details: arr
    resp
