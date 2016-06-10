IdeaMapr.Views.SurveyQuestionsManager = Backbone.View.extend
  initialize: ->
    _.bindAll(@, 'render')

    @assigned_collection = new IdeaMapr.Collections.SurveyQuestionCollection()
    @assigned_collection.listenTo(@assigned_collection, 'add', @assigned_collection.append_rank)
    
    @selected_view = new IdeaMapr.Views.AdminAssignedQuestionListView
      el: $('#selected-list')
      collection: @assigned_collection

    @to_search_collection = new IdeaMapr.Collections.SurveyQuestionCollection()
    @to_search_collection.listenTo(@to_search_collection, 'add', @to_search_collection.append_rank)
    
    @search_view = new IdeaMapr.Views.AdminSearchQuestionListView
      el: $('#search-box')
      collection: @to_search_collection
      model: new IdeaMapr.Models.SearchQueryModel()
      
    @listenTo(@collection, 'change:promoted', @redistribute)
    @listenTo(@collection, 'sync', @distribute)
    @listenTo(@, 'ready_to_render', @render)
    
    console.log 'sq manager: finished init'
    @

  redistribute: (m) ->
    # Move the model into or out of the assigned idea list, and re-distribute ranks
    if m.get('promoted') == 1
      m.set('ranking', @assigned_collection.models.length)
      @assigned_collection.add m      
      @selected_view.example_count -= 1
      @search_view.added_count += 1
      @to_search_collection.remove m
      m.set('promoted', 0)
      @render()
    else if m.get('promoted') == -1
      # It came from the assigned list
      @to_search_collection.add m
      @assigned_collection.remove m
      @assigned_collection.reset_ranks()
      @selected_view.example_count += 1
      @search_view.added_count -= 1
      m.set('promoted', 0)
      @render()
    
  distribute: (opts) ->
    # Now I have the questions, they have to be assigned to the two avlbl views

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
      
    arr
