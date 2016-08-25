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
      img_box = @$el.find '.idea-image'

      if switch_to == 'full'
        @$el.find('.idea-attachments').show()
        img_box.addClass 'summary'
      else
        @$el.find('.idea-attachments').hide()
        img_box.removeClass 'summary'
          
      false
      
  run_summary_logic: (idea) ->
    # Decide whether to show the expansion behavior
    @$el.find('.idea-attachments').hide()
    if @model.has_expansion
      @$el.find('.full').hide()
      for idea_hash in idea.get('attachments')['attachment_urls']
        root = $('<div>').addClass('centered-cell')
        a = $('<a>').text idea_hash.filename
        a.attr 'href', idea_hash.url
        a.attr 'target', '_blank'
        a.attr 'rel', 'noopener noreferrer'
        
        root.append a 
        @$el.find('.idea-attachments').append root
    else
      @$el.find('.full .moreless-text').hide()
      @$el.find('.summary').hide()
