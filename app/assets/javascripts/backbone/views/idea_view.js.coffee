IdeaMapr.Views.IdeaView = Backbone.View.extend
  className: 'idea-box col-xs-12',
  
  initialize: ->
    _.bindAll(this, 'reveal_idea')
    @listenTo(@model, "idea:finish_move_to_top", @reveal_idea)
    
  events:
    'click .addnote': (evt) ->
      $(evt.target).closest('.note-holder').find('textarea').toggle()
    "click .move-to-ranked": ->
      this.model.trigger('idea:moved_to_ranked', this.model, {'action' : 'rank-it'})
    "click .ranked-sign": (evt) ->
      options['action'] = 'change-rank'
      if $(evt.target).hasClass('plus-sign')
        options['direction'] = '+'
      else
        options['direction'] = '-'      
      this.model.trigger 'idea:change_rank', this.model, options

  reveal_idea: (model) ->
    this.$('.move-to-ranked').hide()
    this.$('.ranking-sign').show()
    
  render: ->
    qn_type = this.question_type
    template = _.template($('#' + this.type_names[qn_type] + '-idea-template').html())
    data = this.model.attributes

    if qn_type == 0
      data['note_counts'] =
        pro: this.model.get('pro')
        con: this.model.get('con')
    else if qn_type == 1
      data['index'] = this.model.shown_rank()
      
    this.$el.html(template(data))
    switch qn_type
      when 0
        this.$('.procon-list').hide()
      when 1
        if this.model.get('idea_rank') < 0
          this.$('.ranking-sign').hide()
        else
          this.$('.move-to-ranked').hide()
    
    this
    
  create_entry: (type) ->
    this.model.increment_note type
    this.render()
    
