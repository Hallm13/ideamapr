IdeaMapr.Views.AdminAssignedQuestionListView = IdeaMapr.Views.QuestionListView.extend
  initialize: ->
    _.bindAll(@, 'render')

    @listenTo(@collection, 'change:ranked', @sort_and_render)
    @

  sort_and_render: (m, new_val) ->
    if new_val == 0 # avoid infinite recursion
      return

    @collection.rerank_and_sort(m, new_val)
    @render()
    
  render: ->
    viewself = @
    # clear!
    @$el.html ''
    @collection.each (m) ->
      child_view = new IdeaMapr.Views.AdminAssignedQuestionView
        model: m
      viewself.$el.append(child_view.render().el)
      
    if @example_count > 0
      for num in [0..@example_count-1]
        m = new IdeaMapr.Models.SurveyQuestion()

        # should there be examples?
        if false
          m.make_example()
          child_view = new IdeaMapr.Views.AdminAssignedQuestionView
            model: m
          child_view.question_type = viewself.question_type
          @$el.append(child_view.render().el)
    @