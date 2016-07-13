IdeaMapr.Views.SurveyQuestionsManager = IdeaMapr.Views.IdeaListView.extend
  initialize: ->
    _.bindAll(@, 'render')

    @assigned_collection = new IdeaMapr.Collections.SurveyQuestionCollection()

    # The serialize() method will need this survey token to identify the collection as
    # belonging to a survey.
    @assigned_collection.survey_token = @collection.survey_token
    
    # Let the SQ model know where the selected questions are.
    @model.assigned_questions = @assigned_collection
    
    @selected_view = new IdeaMapr.Views.AdminAssignedQuestionListView
      el: $('#selected-list')
      collection: @assigned_collection

    @to_search_collection = new IdeaMapr.Collections.SurveyQuestionCollection()
    @to_search_collection.listenTo(@to_search_collection, 'add', @to_search_collection.append_rank)
    
    @search_view = new IdeaMapr.Views.AdminSearchQuestionListView
      el: $('#search-box')
      collection: @to_search_collection
      model: new IdeaMapr.Models.SearchQueryModel()
      
    @listenTo(@assigned_collection, 'remove', @redistribute)
    @listenTo(@to_search_collection, 'remove', @redistribute)

    # the distribute will also render this view.    
    @listenToOnce(@collection, 'sync', @distribute)
    @

  render: ->
    @selected_view.render()
    @search_view.render()
