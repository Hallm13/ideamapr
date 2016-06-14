IdeaMapr.Views.PublicIdeaView = Backbone.View.extend
  className: 'col-xs-12 idea-box',
  tagName: 'div',
     
  initialize: ->
    _.bindAll(@, 'render')
    @

  events:
    'keyup #current_pro': (evt) ->
      @model.set_response_data('pro_text', $(evt.target).val())
    'keyup #current_con': (evt) ->
      @model.set_response_data('con_text', $(evt.target).val())
      
  render: ->
    template_id = '#type-' + @question_type + '-public-template'
    html = _.template($(template_id).html())(@model.attributes)
    @$el.html html
    
    @
