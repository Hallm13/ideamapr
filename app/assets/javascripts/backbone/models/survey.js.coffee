IdeaMapr.Models.Survey = Backbone.Model.extend
  initialize: ->
    @listenTo(this, 'survey:recrement_question', @recrement_selection)

  defaults: ->
    current_question: 0
    public_link: 'none'
    
  urlRoot: '/surveys/',
  url: ->
    if @admin_mode
      @urlRoot + @get('id')
    else
      @urlRoot + 'public_show/' + @get('public_link')
    
  recrement_selection: (options) ->
    @set('previous_selection', @get('current_question'))
    if options.direction == -1
      @set('current_question', (@get('current_question') - 1 + @get('number_of_screens')) % @get('number_of_screens'))
    else if options.direction == 1
      @set('current_question', (@get('current_question') + 1) % @get('number_of_screens'))
    
    @trigger 'survey:selection_changed'
