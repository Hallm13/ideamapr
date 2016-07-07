IdeaMapr.Views.AdminDetailsCollectionView = IdeaMapr.Views.IdeaListView.extend
  # The model for this view is the SQ it is in.
  initialize: ->
    # Super (in Backbone) - well, basically we explicitly call what we know is our
    # parent prototype.
    IdeaMapr.Views.IdeaListView.prototype.initialize.call @
    @existing_detail_count = 0
    
    qn_type = @model.get('question_type')
    if qn_type == -1
      # this happens for new surveys
      @question_type = 5
    else
      @question_type = @model.get('question_type')
    
    @listenTo(@model.field_details, 'sort', @render)
    @listenTo(@model.field_details, 'change:ready_for_render', @render)
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
      m.set('idea_rank', @model.field_details.models.length - 1)
      @model.field_details.add m
      @render()
      @

  remove_detail: (detail_view) ->
    # The remove will trigger the ranks reset
    @model.field_details.remove detail_view.model
    @render()
    @
    
  render: ->
    t = _.template($('#details-collection-template').html())
    @$el.html(t())
    view_self = @
    
    @model.field_details.each (model) ->
      @existing_detail_count += 1
      component_view = new IdeaMapr.Views.AdminDetailView
        model: model
      component_view.question_type = view_self.question_type

      view_self.listenTo component_view, 'detail_view:remove_detail', view_self.remove_detail
      view_self.$('#options-list').append(component_view.render().el)
      
    @
  
