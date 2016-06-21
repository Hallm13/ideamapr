IdeaMapr.Views.PublicIdeaView = Backbone.View.extend
  className: 'col-xs-12 idea-box',
  tagName: 'div',
     
  initialize: ->
    _.bindAll(@, 'render')
    @pro_text = ''
    @con_text = ''
    
    @listenTo(@model, 'idea:new_procon', @render)
    @

  events:
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
      
  render: ->
    qn_type = @question_type
    @model.init_type_specific_data(qn_type)
      
    template_id = '#type-' + @question_type + '-public-template'
    html = _.template($(template_id).html())(@model.attributes)
    @$el.html html
    
    switch qn_type
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
