IdeaMapr.Views.PublicIdeaListView = IdeaMapr.Views.IdeaListView.extend
  className: 'row'
  
  initialize: ->
    _.bindAll(@, 'render')

    # Ranking
    @listenTo @collection, 'sort', @render
    
    # Budgeting
    @listenTo(@collection, 'change:cart_count', @change_spent_amount)
    @
      
  render: ->
    view_self = @
    # clear!
    @$el.html ''
    view_self = @
    
    @collection.each (m) ->
      child_view = new IdeaMapr.Views.PublicIdeaView
        model: m
        collection: view_self.collection
      child_view.question_type = view_self.question_type
      view_self.$el.append(child_view.render().el)

    # Budget questions will need an extra line. Eventually this might have to be broken out into
    # spl logic for all the question types.

    if @question_type == 3
      @$el.prepend @budget_line()
    
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
