IdeaMapr.Views.AdminAssignedQuestionListView = IdeaMapr.Views.IdeaListView.extend
  initialize: ->
    _.bindAll(@, 'render')
    @listenTo @collection, 'sort', @render
    
  render: ->
    # The render will be called by the manager view that holds the selected and search views
    view_self = @
    # clear!
    @$el.html ''
    @collection.each (m) ->
      child_view = new IdeaMapr.Views.AdminAssignedQuestionView
        model: m
      view_self.$el.append(child_view.render().el)
      
    if @example_count > 0
      for num in [0..@example_count-1]
        m = new IdeaMapr.Models.SurveyQuestion()

        # should there be examples?
        if false
          m.make_example()
          child_view = new IdeaMapr.Views.AdminAssignedQuestionView
            model: m
          child_view.question_type = view_self.question_type
          @$el.append(child_view.render().el)
    @
