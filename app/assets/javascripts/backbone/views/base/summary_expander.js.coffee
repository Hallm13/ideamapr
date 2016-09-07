IdeaMapr.Views.SummaryExpander = ->
  # General utility functions - this name is a bit of a misnomer now. 

  @toggle_switch = (x) ->
    # Call AFTER using the switch-to data attribute 
    switch x.data('switch-to')
      when 'full'
        set_to = 'summary'
        newtext = 'Read less'
      when 'summary'
        set_to = 'full'
        newtext = 'Read more'
      
    x.data 'switch-to', set_to
    x.text newtext
    x
    
  @expander_events = ->
    'click .moreless-text': (evt) ->
      # Works iff the click happens on a node that contains data-switch-to as an attribute
      # which points to a class name that exists for a span that's the child of this event's target's
      # sibling. Got that? ;)

      evt.stopPropagation()
      x = $(evt.target)
      switch_to = x.data('switch-to')
      # Change the button itself.
      @toggle_switch(x)
      
      desc_container = x.prev('.idea-description')
      desc_container.find('span.wrapper').hide()
      desc_container.find('span.' + switch_to).show()
      
      img_box = @$el.find '.idea-image'

      if switch_to == 'full'
        @$el.find('.idea-attachments').show()
        img_box.addClass 'summary'
      else
        @$el.find('.idea-attachments').hide()
        img_box.removeClass 'summary'
          
      false
      
  @run_summary_logic = (idea) ->
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
  
  @add_br_tags = (str) ->
    if str == null
      ''
    else
      s = str.replace(/\r\n(\r\n)+/g, '<p></p>')
      s.replace(/\n(\n)+/g, '<p></p>')
  @
