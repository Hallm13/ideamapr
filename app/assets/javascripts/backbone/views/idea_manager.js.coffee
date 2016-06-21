IdeaMapr.Views.IdeaManager = Backbone.View.extend
  initialize: ->
    _.bindAll(@, 'render')

    @assigned_collection = new IdeaMapr.Collections.IdeaCollection()
    @assigned_collection.listenTo(@assigned_collection, 'add', @assigned_collection.append_rank)
    
    @selected_view = new IdeaMapr.Views.AdminAssignedIdeaListView
      el: $('#selected-list')
      collection: @assigned_collection

    @to_search_collection = new IdeaMapr.Collections.IdeaCollection()
    @to_search_collection.listenTo(@to_search_collection, 'add', @to_search_collection.append_rank)
    
    @search_view = new IdeaMapr.Views.AdminSearchIdeaListView
      el: $('#search-box')
      collection: @to_search_collection
      model: new IdeaMapr.Models.SearchQueryModel()
      
    @listenTo(@collection, 'change:promoted', @redistribute)
    @listenTo(@collection, 'sync', @distribute)
    @listenTo(@, 'ready_to_render', @render)
    @listenTo(@, 'new_type_change', @change_type_and_render)
    
    console.log 'idea manager: finished init'
    @

  change_type_and_render: (new_type) ->
    @set_question_type new_type
    @.trigger('ready_to_render')
    
  set_question_type: (type_id) ->
    @question_type = type_id
    @selected_view.question_type = type_id
    @search_view.question_type = type_id

  redistribute: (m) ->
    # Move the model into or out of the assigned idea list, and re-distribute ranks
    if m.get('promoted') == 1
      m.set('idea_rank', @assigned_collection.models.length)
      @assigned_collection.add m
      @selected_view.example_count -= 1
      @search_view.added_count += 1
      @to_search_collection.remove m
    else if m.get('promoted') == -1
      # It came from the assigned list
      @to_search_collection.add m
      @assigned_collection.remove m
      @assigned_collection.reset_ranks()
      @selected_view.example_count += 1
      @search_view.added_count -= 1

    unless m.get('promoted') == 0
      @render()
      m.set('promoted', 0)
    
  distribute: (opts) ->
    # Now I have the ideas, they have to be assigned to the two avlbl views

    # For testing
    if !(opts.hasOwnProperty('render'))
      opts.render = true
      
    viewself = @
    assigned_total = 0
    avlbl_count = 0
    
    _.each(@collection.models, (m) ->
      if m.get('is_assigned')
        viewself.selected_view.collection.add m
        assigned_total += 1
      else
        viewself.search_view.collection.add m
        avlbl_count += 1
    )
    @search_view.orig_length = avlbl_count
    
    # Set a count for how many example ideas to show, up to a max of 3
    @selected_view.example_count = 3 - assigned_total
    @.trigger('ready_to_render') if opts['render']
    
  render: ->
    console.log 'idea manager: starting render'

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
