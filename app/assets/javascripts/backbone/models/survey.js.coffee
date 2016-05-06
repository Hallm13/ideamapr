IdeaMapr.Models.Survey = Backbone.Model.extend
  initialize: ->
    this.listenTo(this, 'survey:recrement_question', this.recrement_selection)

  defaults: ->
    selected_screen: 0
    
  urlRoot: '/survey/public_show',
  url: ->
    this.urlRoot + '/' + this.get('public_link')
    
  recrement_selection: (options) ->
    this.set('previous_selection', this.get('selected_screen'))
    if options.direction == -1
      this.set('selected_screen', (this.get('selected_screen') - 1 + this.get('number_of_screens')) % this.get('number_of_screens'))
    else if options.direction == 1
      this.set('selected_screen', (this.get('selected_screen') + 1) % this.get('number_of_screens'))
    
    this.trigger 'survey:selection_changed'
