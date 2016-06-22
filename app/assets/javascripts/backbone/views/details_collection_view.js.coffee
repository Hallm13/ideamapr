IdeaMapr.Views.DetailsCollectionView = Backbone.View.extend
  initialize: ->
    _.bindAll(@, 'render')
    @existing_detail_count = 0
    
    @listenTo(@collection, 'ready_to_render', @render)
    @listenTo(@collection, 'change:ready_for_render', @render)
    @listenTo(@collection, 'empty_model', @render)
    
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
      @collection.trigger('empty_model')
      @
      
  render: ->
    t = _.template($('#details-collection-template').html())
    @$el.html(t())
    
    view_self = @
    
    @collection.each (model) ->
      @existing_detail_count += 1
      component_view = new IdeaMapr.Views.DetailView
        model: model
      component_view.question_type = view_self.question_type
      view_self.$('#options-list').append(component_view.render().el)
      
    @
  
