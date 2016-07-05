IdeaMapr.Views.IdeaView = Backbone.View.extend
  className: 'idea-box col-xs-12',
  
  initialize: ->
    _.bindAll(this, 'reveal_idea')
    @listenTo(@model, "idea:finish_move_to_top", @reveal_idea)
    
  events:
    'click .addnote': (evt) ->
      $(evt.target).closest('.note-holder').find('textarea').toggle()
    "click .move-to-ranked": ->
      @model.trigger('idea:moved_to_ranked', @model, {'action' : 'rank-it'})
    "click .ranked-sign": (evt) ->
      options['action'] = 'change-rank'
      if $(evt.target).hasClass('plus-sign')
        options['direction'] = '+'
      else
        options['direction'] = '-'
      @model.trigger 'idea:change_rank', @model, options

  reveal_idea: (model) ->
    @$('.move-to-ranked').hide()
    @$('.ranking-sign').show()
    
  create_entry: (type) ->
    @model.increment_note type
    @render()
    @
