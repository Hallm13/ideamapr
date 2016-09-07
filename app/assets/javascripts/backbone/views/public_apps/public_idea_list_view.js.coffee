IdeaMapr.Views.PublicIdeaListView = IdeaMapr.Views.IdeaListView.extend
  className: 'row'
  
  initialize: ->
    _.bindAll(@, 'render')

    # Suggest Idea
    @form_elt = null
    
    @listenTo @collection, 'sort', @remove_prompt_and_render
    
    # Budgeting
    @remaining_budget_title_html = "Total <span class='bold-text'>Remaining: </span><span class='value'></span>"
    @used_budget_title_html = "Total <span class='bold-text'>Spent</span>: <span class='value'></span>"
    @listenTo(@collection, 'change:cart_count', @change_spent_amount)
    @

  events:
    # The only action collected at the list level is for suggesting ideas
    'click #add-idea': (evt) ->
      if $('#new_idea_title').val().trim().length > 0 and $('#new_idea_description').val().trim().length > 0
        @add_idea_model @form_elt
      else
        evt.stopPropagation()

  remove_prompt_and_render: ->
    # Ranking type requires the removal of this element
    @$el.find('.ranking-prompt').remove()
    @render()
    if @question.get('question_type') == 2
      # new idea - rendering should cause data to be saved - it only happens when ideas are added or deleted.
      @question.post_response_to_server()

  render: ->
    view_self = @
    # clear!
    @$el.html ''
    view_self = @
    
    @collection.each (m) ->
      child_view = new IdeaMapr.Views.PublicIdeaView
        model: m
        collection: view_self.collection
      child_view.question = view_self.question
      if view_self.question.get('question_type') == 1
        # Ranking type should not show ranks to start with
        child_view.show_ranks = (view_self.question.get('answered') == true)
      view_self.$el.append child_view.render().el
      null

    switch @question.get('question_type')
      when 1
        # Ranking: fresh view shd have the helper box at the top
        if !view_self.question.get('answered')
          @$el.prepend @ranking_prompt_box()
      when 3
        # Budget questions will need an extra line before, and new idea question requires add-button after.
        @$el.prepend @redraw_budget_line()
      when 2
        # Suggest Idea needs the form
        @form_elt = @add_idea_form()
        @$el.append @form_elt

    @

  ranking_prompt_box: ->
    root = $('<div>').addClass('col-xs-12 ranking-prompt')
    root.append($('<div>').addClass('help-text').html('Click the + or <span class="red">-</span> to rank'))
    root
    
  change_spent_amount: (m, options) ->
    # m is the model for the idea (cart_amount is added from the idea_assignment that connected to it.)
    current_count = m.get 'cart_count'
    if current_count == 0
      @collection.cart_total_spend -= m.get 'cart_amount'
    else
      @collection.cart_total_spend += m.get 'cart_amount'
    @redraw_budget_line()
    
  redraw_budget_line: ->
    # Return a jQuery object with the HTML for the budget line
    # TODO: generate this from a template instead of jQuery
    
    x = null
    if typeof @budget_root_elt == 'undefined'
      x = $('<div>').addClass('row').append($('<div>').addClass('col-xs-12 budget-line'))
      @budget_root_elt = x.find('.budget-line')
      qty_bkgrd = $('<div>').addClass('quantity-bkgrd')
      qty_bkgrd.append($('<div>').addClass('row'))
      
      @budget_root_elt.append qty_bkgrd
      qty_bkgrd.find('.row').append $('<div>').attr('id', 'used-budget').addClass('col-xs-12 col-sm-6')
      qty_bkgrd.find('.row').append $('<div>').attr('id', 'available-budget').addClass('col-xs-12 col-sm-6')

    avlbl = @budget_root_elt.find '#available-budget'
    spent = @budget_root_elt.find '#used-budget'

    avlbl.html @remaining_budget_title_html
    spent.html @used_budget_title_html
    avlbl.find('.value').text ('$' + (@model.get('budget') - @collection.cart_total_spend))
    spent.find('.value').text ('$' + @collection.cart_total_spend)
    x

  add_idea_form: ->
    form = _.template($('#type-2-add-idea-form-public-template').html())
    elt_root = $('<div>').addClass('row')
    elt_root.append form()
    
    elt_root.append($('<div>').attr('id', 'add-idea').addClass('col-xs-12 btn btn-primary').text('Save'))
    elt_root
    
  add_idea_model: ($elt) ->
    m = new IdeaMapr.Models.Idea
      index: @collection.models.length
      title: $elt.find('#new_idea_title').val()
      description: $elt.find('#new_idea_description').val()
      attachments:
        card_image_url: ''
        attachment_urls: []
        
    m.set 'answered', true
    @question.set 'answered', true
    # this triggers a sort on the collection that posts the data to the server
    @collection.add m
