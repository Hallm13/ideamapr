IdeaMapr.Views.SurveyView = Backbone.View.extend
  className: 'row',
  initialize: ->
    @allowed_list =
      0: 'Draft'
      1: 'Published'
      2: 'Closed'
      
    _.bindAll(this, 'render')
  events:
    'click #status-change-dropdown': (evt) ->
      @$('.dd-choice-list').toggle()
      @trigger('survey_view:dropdown_click', @cid)
      
      this
    'click .dd-choice': (evt) ->
      evt.stopPropagation()
      @model.save
        status: $(evt.target).data('status-key')
        
      @render()
      this
    'click .goto-edit': (evt) ->
      l = $(evt.target).closest('.goto-edit').data('goto-target-template')
      actual_url = l.replace(/0id0/, @model.get('id'))
      window.location.href = actual_url
      
  shut_dropdown: ->
    @$el.find('.dd-choice-list').hide()
    
  render: ->
    @model.set('displayed_survey_status', @allowed_list[@model.get('status')])
    
    @$el.html(_.template($('#survey-listing-template').html())(@model.attributes))
    show_list_keys = _.difference(_.keys(@allowed_list), [@model.get('status')])

    view_self = @
    dd_container = $('<div>').addClass('dd-choice-list')
    view_self.$('#status-change-dropdown').append dd_container
    for key of show_list_keys
      dd_container.append($('<div>').addClass('dd-choice').data('status-key', key).text(@allowed_list[key]))
      
    # Remove the public link if it's not published
    if @model.get('status') != 1
      @$el.find('#public-link').remove()
    @
