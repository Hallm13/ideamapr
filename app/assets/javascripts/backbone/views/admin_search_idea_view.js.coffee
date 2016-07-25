IdeaMapr.Views.AdminSearchIdeaView = IdeaMapr.Views.SurveyQuestionIdeaEditView.extend
  top_container_class: 'component-box'
  initialize: ->
    _.bindAll(@, 'render')
    @extend_events()
    @top_container_selector = '.' + @top_container_class
    @$el.addClass @top_container_class
    @run_summary_logic = (new IdeaMapr.Views.SummaryExpander).run_summary_logic

    @

  extend_events: ->
    @events = 
      'click .add-box': (evt) ->
        @model.set('ranked', -10)
    # Add in the expander behavior.
    _.extend(@events, (new IdeaMapr.Views.SummaryExpander()).events)
    @delegateEvents()
          
  render: ->
    template_id = '#idea-search-template'
    html = _.template($(template_id).html())(@model.attributes)
    @$el.html html
    @add_image_margin()
    @run_summary_logic()
    @
