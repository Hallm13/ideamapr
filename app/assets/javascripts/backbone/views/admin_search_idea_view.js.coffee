IdeaMapr.Views.AdminSearchIdeaView = IdeaMapr.Views.SurveyQuestionIdeaEditView.extend
  top_container_class: 'component-box'
  initialize: ->
    _.bindAll(@, 'render')
    @extend_events()
    @top_container_selector = '.' + @top_container_class
    @$el.addClass @top_container_class
    _.extend(@, new IdeaMapr.Views.SummaryExpander())
    @run_summary_logic = (new IdeaMapr.Views.SummaryExpander).run_summary_logic

    @

  extend_events: ->
    @events = 
      'click .add-box': (evt) ->
        @model.set('ranked', -10)
    # Add in the expander behavior.
    _.extend(@events, (new IdeaMapr.Views.SummaryExpander()).expander_events)
    @delegateEvents()
          
  render: ->
    template_id = '#idea-search-template'
    @model.set('description_with_breaks', @add_br_tags(@model.get('description')))
    
    html = _.template($(template_id).html())(_.extend({}, @model.attributes, {card_image_url: @model.get('attachments')['card_image_url']}))
    @$el.html html
    @add_image_margin()
    @run_summary_logic @model
    @
