IdeaMapr.Views.AdminDetailsCollectionView = IdeaMapr.Views.IdeaListView.extend
  initialize: ->
    # Super (in Backbone)
    IdeaMapr.Views.IdeaListView.prototype.initialize.call @
    @existing_detail_count = 0
    
    @listenTo(@collection, 'ready_to_render', @render)
    @listenTo(@collection, 'change:ready_for_render', @render)
    
    @

  set_question_type: (t) ->
    @collection.question_type = t
    @question_type = t
    @

  serialize_models: ->
    arr = new Array()
    _.each @collection.models, (m) ->
      arr.push m

    resp =
      question_type: @question_type
      details: arr
    resp
    
  events:
    'click #add-button': (evt) ->
      m = new IdeaMapr.Models.DetailComponent()
      m.set('idea_rank', @collection.models.length - 1)
      @collection.add m
      @render()
      @
      
  render: ->
    t = _.template($('#details-collection-template').html())
    @$el.html(t())
    
    view_self = @
    
    @collection.each (model) ->
      @existing_detail_count += 1
      component_view = new IdeaMapr.Views.AdminDetailView
        model: model
      component_view.question_type = view_self.question_type
      view_self.$('#options-list').append(component_view.render().el)
      
    @
  
