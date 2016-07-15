IdeaMapr.Views.PublicIdeaListView = IdeaMapr.Views.IdeaListView.extend
  className: 'row'
  
  initialize: ->
    _.bindAll(@, 'render')

    # Suggest Idea
    @form_elt = null
    
    # Ranking
    @listenTo @collection, 'sort', @render
    
    # Budgeting
    @listenTo(@collection, 'change:cart_count', @change_spent_amount)
    @

  events:
    # The only action collected at the list level is for suggesting ideas
    'click #add-idea': (evt) ->
      if $('#new_idea_title').val().trim().length > 0 and $('#new_idea_description').val().trim().length > 0
        @add_idea_model @form_elt
      else
        evt.stopPropagation()
        
  render: ->
    view_self = @
    # clear!
    @$el.html ''
    view_self = @
    
    @collection.each (m) ->
      if m.id == -1
        # Dummy idea returned for Suggest Idea question type
        return null
        
      child_view = new IdeaMapr.Views.PublicIdeaView
        model: m
        collection: view_self.collection
      child_view.question_type = view_self.question_type
      view_self.$el.append(child_view.render().el)
      null

    # Budget questions will need an extra line before, and new idea question requires add-button after.
    # Eventually this might have to be broken out into spl logic for all the question types.

    if @question_type == 3
      @$el.prepend @budget_line()

    if @question_type == 2
      unless @form_elt == null
        @form_elt.remove()
        
      @form_elt = @add_idea_form()
      @$el.append @form_elt
    @

  change_spent_amount: (m, options) ->
    # m is the model for the idea (cart_amount is added from the idea_assignment that connected to it.)
    current_count = m.get 'cart_count'
    if current_count == 0
      @collection.cart_total_spend -= m.get 'cart_amount'
    else
      @collection.cart_total_spend += m.get 'cart_amount'
    @set_budget @$el, @collection.cart_total_spend
    
  budget_line: ->
    # Return a jQuery object with the HTML for the budget line
    elt_root = $('<div>').addClass('col-xs-12')
    elt_root.append $('<span>').attr('id', 'available-budget').text('Available budget: ' + @collection.budget)
    elt_root.append $('<span>').attr('id', 'used-budget')
    @set_budget(elt_root, @collection.cart_total_spend)
    elt_root

  set_budget: ($root, amt) ->
    $root.find('#used-budget').text 'Used budget: ' + amt

  add_idea_form: ->
    form = _.template($('#type-2-add-idea-form-public-template').html())
    elt_root = $('<div>').addClass('row')
    elt_root.append form()
    
    elt_root.append($('<div>').attr('id', 'add-idea').addClass('col-xs-12 btn btn-primary').text('Add Another'))
    elt_root
    
  add_idea_model: ($elt) ->
    m = new IdeaMapr.Models.Idea
      title: $elt.find('#new_idea_title').val()
      description: $elt.find('#new_idea_description').val()
    @collection.add m
  
      
