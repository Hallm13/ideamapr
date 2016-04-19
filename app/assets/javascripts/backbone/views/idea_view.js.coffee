IdeaMapr.Views.IdeaView = Backbone.View.extend
  className: 'idea-box',
  
  initialize: ->
    _.bindAll(this, 'render')
    this.listenTo(this.model, "change", this.render)

  events: 
    'click .addnote': (evt) ->
      $(evt.target).closest('.note-holder').find('textarea').toggle()
    'click #move-to-top': (evt) ->
      this.model.trigger('move-top')
        
  render: ->
    if this.qn_type == 0 # SurveyQuestion::QuestionType::PROCON
      template = _.template($('#procon-template').html())
    else if this.qn_type == 1 # SurveyQuestion::QuestionType::RANKING
      template = _.template($('#ranking-template').html())

    data = this.model.attributes

    if this.qn_type == 0
      data['note_counts'] =
        pro: this.model.get('pro')
        con: this.model.get('con')
    else if this.qn_type == 1
      data['idea_rank'] = this.model.get('idea_rank')
      
    this.$el.html(template(data))
    this.$('textarea').hide()
    this
    
  create_entry: (type) ->
    this.model.increment_note type
    this.render()
    
  set_type: (type_int) ->
    this.qn_type = type_int
