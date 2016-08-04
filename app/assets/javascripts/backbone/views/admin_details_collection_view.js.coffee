IdeaMapr.Views.AdminDetailsCollectionView = IdeaMapr.Views.IdeaListView.extend
  # The model for this view is the SQ it is in.
  initialize: ->
    @listenTo(@model.field_details, 'sort', @render)

    # This sync happens because trigger_fetches() in SurveyQuestion causes a fetch on this collection
    @listenTo @model.field_details, 'sync', @render
    # If the text in one of the details changes, the entire list has to be re-rendered.
    @listenTo @model.field_details, "change:ready_for_render", @render
    
    @

  serialize_models: ->
    arr = new Array()
    _.each @model.field_details.models, (m) ->
      arr.push m

    resp =
      question_type: @question_type
      details: arr
    resp

  events:
    'click #add-button': (evt) ->
      m = new IdeaMapr.Models.DetailComponent()
      m.set_blank()
      @model.field_details.append_model m
      @
      
  render: ->
    qn_type = @model.get('question_type')    
    if qn_type == 1
      # this happens for new surveys
      @question_type = 5
    else
      @question_type = @model.get('question_type')
    
    t = _.template($('#details-collection-template').html())
    @$el.html t()
    
    view_self = @

    available_slots = 3    
    @model.field_details.each (model) ->
      available_slots -= 1
      component_view = new IdeaMapr.Views.AdminDetailView
        model: model
      component_view.question_type = view_self.question_type
      view_self.$('#options-list').append(component_view.render().el)
      
    @add_example_views
      available_slots: available_slots
      type: 'detail'
      $root: @$el.find('#options-list')
    
    @
  
