IdeaMapr.Models.Survey = Backbone.Model.extend
  initialize: ->
    @listenTo(this, 'survey:recrement_question', @recrement_selection)

  defaults: ->
    selected_screen: 0
    
  urlRoot: '/survey/',
  url: ->
    if @admin_mode
      @urlRoot + @get('id')
    else
      @urlRoot + '/public_show/' + @get('public_link')
    
  recrement_selection: (options) ->
    @set('previous_selection', @get('selected_screen'))
    if options.direction == -1
      @set('selected_screen', (@get('selected_screen') - 1 + @get('number_of_screens')) % @get('number_of_screens'))
    else if options.direction == 1
      @set('selected_screen', (@get('selected_screen') + 1) % @get('number_of_screens'))
    
    @trigger 'survey:selection_changed'
