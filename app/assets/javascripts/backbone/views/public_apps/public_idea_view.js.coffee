IdeaMapr.Views.PublicIdeaView = Backbone.View.extend
  top_container_class: 'idea-box'
  tagName: 'div'
  
  initialize: ->
    _.bindAll(@, 'render')

    @orig_editarea_padding =
      title: ''
      description: ''

    @shown_box = ''
    @pro_text = ''
    @con_text = ''
    @top_container_selector = '.' + @top_container_class
    @$el.addClass @top_container_class
    @listenTo(@model, 'idea:new_procon', @render)
    @

  events:
    # Ranking
    'click .up': (evt) ->
      # Cannot move top idea up
      unless @model.get('component_rank') == 0
        @model.set 'answered', 1
        @model.set 'ranked', 1
    'click .down': (evt) ->
      # Cannot move bottom idea down but this view can't tell - so the collection
      # that listens to this event has to.
      @model.set 'answered', 1
      @model.set 'ranked', -1
    
    # Procon
    "click #addpro": ->
      @show_textarea 'pro'
    "click #addcon": ->
      @show_textarea 'con'
    "click #save-procon": (evt) ->
      @model.add_feedback $(evt.target).data('fdbk-type'), @pro_text
      @remove_textarea()
    'keyup #current-procon': (evt) ->
      if @shown_box == 'pro'
        @pro_text = $(evt.target).val()
      else
        @con_text = $(evt.target).val()

    # Budgeting
    "click #add-to-cart": (evt) ->
      # The collection here is the IdeaCollection it is in.
      if $(evt.target).data('action') == 'remove' or @collection.accept_cart_item(@model.get('cart_amount'))
        @toggle_cart_text $(evt.target)
        @model.toggle_cart_count()
        
    # Suggest Idea
    'keyup .edit-areas': (evt) ->
      @model.set_text_entry $(evt.target).attr('id'), $(evt.target).val().trim()

  render: ->
    @model.init_type_specific_data(@question_type)
    unless @model.get('id') == -1
      # id == -1, when the model is a dummy, in the Suggest Idea question type
      template_id = '#type-' + @question_type + '-public-template'
      html = _.template($(template_id).html())(@model.attributes)
      @$el.html html
    
    switch @question_type
      when 0
        @append_procon_boxes()
        @$('.procon-list').hide()
    
    @

  append_procon_boxes: ->
    root = @$('#current-procon-list-wrapper')
    pro_root = root.find '#pro-column'
    con_root = root.find '#con-column'

    @model.get('response_data')['type-0-data']['feedback']['pro'].forEach (text_elt, idx) ->
      div = $(_.template($('#procon-entry').html())({text: text_elt}))
      pro_root.find('.row').append div
    @model.get('response_data')['type-0-data']['feedback']['con'].forEach (text_elt, idx) ->
      div = $(_.template($('#procon-entry').html())({text: text_elt}))
      con_root.find('.row').append div

  show_textarea: (type) ->
    # Switch all the visible buttons around in this row.
    # Some of the calls below might be no-ops.
    root = @$('#current-procon-list-wrapper')
    @$('#current-procon-list-wrapper .input-row').show()
    div = root.find '.input-row .input-controls'
    switch type
      when 'pro'
        @shown_box = 'pro'
        div.removeClass 'col-xs-offset-6'
        @$('#addpro').hide()
        @$('#addcon').show()        
      when 'con'
        @shown_box = 'con'
        div.addClass 'col-xs-offset-6'
        @$('#addpro').show()
        @$('#addcon').hide()
    div.find('#save-procon').data('fdbk-type', type)    
    div.find('textarea').focus()    
    
  remove_textarea: (type) ->
    @shown_box = ''    
    @$('#current-procon-list-wrapper .input-row').hide()
    @$('#addpro').show()
    @$('#addcon').show()        
    elt.val ''
        
  toggle_cart_text: ($button) ->
    if $button.data('action') == 'add'
      $button.text 'Remove from Cart'
      $button.data 'action', 'remove'
    else
      $button.text 'Add to Cart'
      $button.data 'action', 'add'
