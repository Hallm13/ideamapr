# Base class for AdminAssignedQuestionListView, AdminAssignedIdeaListView, PublicIdeaListView which use the sort trigger,
# and for AdminDetailsCollectionView, AdminIdeaCollectionsView, and SurveyQuestionsManager, which all use populate_data()
# while the first two use assign_dummy_components.

# TODO separate into two base classes? one for managing a single list, and one for managing two interacting lists?
# TODO make AdminSearchIdeaListView a child of this? at this point, it's not sortable, so maybe not.

IdeaMapr.Views.IdeaListView = Backbone.View.extend
  tagName: 'div',

  populate_data: ->
    # This triggers the fetches on whichever lists the SQ model for this listing view
    # contains
    @model.trigger_fetches()
    
  distribute: (coll) ->
    # Now I have the components, they have to be assigned to the two avlbl views, search and selected
    view_self = @

    if coll.hasOwnProperty('survey_question_id')
      @container = 'survey_question'
    else
      @container = 'survey'
      
    assigned_total = 0
    avlbl_count = 0
    
    _.each(@model.component_list().models, (m) ->
      if view_self.container == 'survey_question'
        child = new IdeaMapr.Models.Idea(m.attributes)
      else
        child = new IdeaMapr.Models.SurveyQuestion(m.attributes)

      if m.get('is_assigned') == true
        view_self.selected_view.collection.add child,
          sort: false
        assigned_total += 1
      else
        view_self.search_view.collection.add child,
          sort: false
        avlbl_count += 1
    )
    
    @search_view.orig_length = avlbl_count
    
    # Set a count for how many example ideas to show, up to a max of 3
    @selected_view.example_count = 3 - assigned_total
    @render()
    
  redistribute: (m) ->
    # Move the model into or out of the assigned idea or qn list, and re-distribute ranks
    m.set('ranked', 0)
    if m.get('is_assigned') == false
      m.set 'is_assigned', true
      m.set 'component_rank', @assigned_collection.models.length
      @assigned_collection.add m
      @search_view.added_count += 1
    else
      # It came from the assigned list
      @to_search_collection.add m
      m.set 'is_assigned', false
      @assigned_collection.reset_ranks()
      @search_view.added_count -= 1

    @render()

  add_example_views: (opts) ->
    # This is a single view of either ideas or details, that need to be "filled out" with
    # examples.
    view_self = @
    if opts.available_slots > 0
      start_index = 3 - opts.available_slots
      for num in [start_index..2]
        if opts.type == 'idea'
          model = new IdeaMapr.Models.Idea()
        else
          model = new IdeaMapr.Models.DetailComponent()
          
        model.make_example
          rank: num

        if opts.type == 'idea'
          child_view = new IdeaMapr.Views.AdminAssignedIdeaView
            model: model
        else
          child_view = new IdeaMapr.Views.AdminDetailView
            model: model
          view_self.listenTo(child_view, 'detail:new_model', view_self.model.field_details.append_model)
        
        child_view.question_type = view_self.question_type
        opts.$root.append child_view.render().el
