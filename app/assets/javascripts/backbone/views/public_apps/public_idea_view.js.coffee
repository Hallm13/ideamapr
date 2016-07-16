IdeaMapr.Views.PublicIdeaView = Backbone.View.extend
  top_container_class: 'idea-box'
  tagName: 'div'
  
  initialize: ->
    _.bindAll(@, 'render')

    @orig_editarea_padding =
      title: ''
      description: ''
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
      @append_textarea 'pro'
      @remove_textarea 'con'
    "click #savepro": ->
      @model.add_feedback 'pro', @pro_text
      @remove_textarea 'pro'
    "click #savecon": ->
      @model.add_feedback 'con', @con_text
      @remove_textarea 'con'
    "click #addcon": ->
      @append_textarea 'con'
      @remove_textarea 'pro'
    'keyup #current-pro': (evt) ->
      @pro_text = $(evt.target).val()
    'keyup #current-con': (evt) ->
      @con_text = $(evt.target).val()

    # Budgeting
    "click #add-to-cart": (evt) ->
      # The collection here is the IdeaCollection it is in.
      if @collection.accept_cart_item(@model.get('cart_amount'))
        @toggle_cart_text $(evt.target)
        @model.toggle_cart_count()
        
    # Suggest Idea
      
  render: ->
    @model.init_type_specific_data(@question_type)
      
    template_id = '#type-' + @question_type + '-public-template'
    html = _.template($(template_id).html())(@model.attributes)
    @$el.html html
    
    switch @question_type
      when 0
        @append_procon_boxes()
        @$('.procon-list').hide()
    
    @

  append_procon_boxes: ->
    root = @$('#current-procon-list')
    pro_root = $('<div>').addClass('col-xs-6 #pro-column')
    pro_root.append $('<div>').addClass('row')
    root.append pro_root
    con_root = $('<div>').addClass('col-xs-6 #con-column')
    con_root.append $('<div>').addClass('row')
    root.append con_root

    # TODO: Hide this object schema in a method
    @model.get('response_data')['type-0-data']['feedback']['pro'].forEach (text_elt, idx) ->
      div = $('<div>').addClass('col-xs-12').addClass('gray-bordered-box').text text_elt
      pro_root.find('.row').append div
    @model.get('response_data')['type-0-data']['feedback']['con'].forEach (text_elt, idx) ->
      div = $('<div>').addClass('col-xs-12').addClass('gray-bordered-box').text text_elt
      con_root.find('.row').append div

  append_textarea: (type) ->
    root = @$('#current-procon-list')
    switch type
      when 'pro'
        div = $('<textarea>').attr('rows', 5).addClass('col-xs-6').attr('id', 'current-pro')
        @$('#addpro').hide()
        @$('#savepro').show()
      when 'con'
        div = $('<textarea>').attr('rows', 5).addClass('col-xs-offset-6 col-xs-6').attr('id', 'current-con')
        @$('#addcon').hide()
        @$('#savecon').show()
    root.append div
    
  remove_textarea: (type) ->
    switch type
      when 'pro'
        @$('textarea#current-pro').remove()
        @$('#addpro').show()
        @$('#savepro').hide()
      when 'con'
        @$('textarea#current-con').remove()
        @$('#addcon').show()
        @$('#savecon').hide()
        
  toggle_cart_text: ($button) ->
    if $button.text().match(/Add/) != null
      $button.text 'Remove from Cart'
    else
      $button.text 'Add to Cart'
