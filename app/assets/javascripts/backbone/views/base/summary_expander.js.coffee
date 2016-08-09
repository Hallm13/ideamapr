IdeaMapr.Views.SummaryExpander = Backbone.View.extend
  events:
    'click .moreless-text': (evt) ->
      # Works if the click happens on a node that contains data-switch-to as an attribute
      # which points to a class name that exists for a span in the inheritor view's base element,
      # and evt target has an ancestor that is a 'span.wrapper' element (which is where the event target itself
      # lives.) Got that? ;)

      evt.stopPropagation()
      x = $(evt.target)      
      switch_to = x.data('switch-to')
      x.closest('span.wrapper').hide()
      @$('span.' + switch_to).show()
      false
      
  run_summary_logic: ->
    # Decide whether to show the expansion behavior
    if @model.has_expansion
      @$el.find('.full').hide()
    else
      @$el.find('.full .moreless-text').hide()
      @$el.find('.summary').hide()
