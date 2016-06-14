IdeaMapr.Models.Survey = Backbone.Model.extend
  initialize: ->
    _.bindAll(@, 'populate_idea_collections')
    @listenTo(@, 'survey:recrement_question', @recrement_selection)
    @listenTo(@, 'sync', _.once(@fetch_idea_lists))
        
  fetch_idea_lists: ->
    # This is triggered when the sync is done the first time, in order to fetch ideas.
    @idea_list = new IdeaMapr.Models.IdeaListOfLists()
    @idea_list.survey_token = @.get('public_link')
    @idea_list.fetch
      success: @populate_idea_collections

  populate_idea_collections: (model, response, options) ->
    # Survey takes the list of idea lists and stores them in an array to communicate to the individual
    # Survey questions - is this too complicated?

    model_self = @
    @idea_lists = []
    _.each(model.get('list_of_lists'), (component_hash) ->
      if component_hash['type'] == 'idea'
        model_self.idea_lists.push new IdeaMapr.Collections.IdeaCollection(component_hash['data'])
      else
        model_self.idea_lists.push new IdeaMapr.Collections.DetailsCollection(component_hash['data'])
    )

    @trigger('survey:has_ideas')
    @
    
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
