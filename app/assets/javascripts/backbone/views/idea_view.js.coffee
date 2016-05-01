IdeaMapr.Views.IdeaView = Backbone.View.extend
  className: 'idea-box',
  
  initialize: ->
    _.bindAll(this, 'render')
    this.listenTo(this.model, "change", this.render)
    this.type_names =
      0: 'procon'
      1: 'ranking'
      
  events: 
    'click .addnote': (evt) ->
      $(evt.target).closest('.note-holder').find('textarea').toggle()
    'click #move-to-top': (evt) ->
      this.model.trigger('move-top')

  set_question_type: (type_int) ->
    this.question_type = type_int
            
  render: ->
    qn_type = this.question_type
    template = _.template($('#' + this.type_names[qn_type] + '-template').html())
    data = this.model.attributes

    if qn_type == 0
      data['note_counts'] =
        pro: this.model.get('pro')
        con: this.model.get('con')
    else if qn_type == 1
      data['idea_rank'] = this.model.get('idea_rank')
      
    this.$el.html(template(data))
    this.$('textarea').hide()
    this
    
  create_entry: (type) ->
    this.model.increment_note type
    this.render()
