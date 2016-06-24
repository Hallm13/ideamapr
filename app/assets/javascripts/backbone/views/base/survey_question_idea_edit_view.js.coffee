# Base class for AdminAssignedIdeaView and AdminDetailView
IdeaMapr.Views.SurveyQuestionIdeaEditView = Backbone.View.extend
  className: 'col-xs-12',
  tagName: 'div',

  base_events:
    'click #up': (evt) ->
      # Cannot move top idea up
      unless @model.get('idea_rank') == 0
        @model.set('ranked', 1)
    'click #down': (evt) ->
      # Cannot move bottom idea down but this view can't tell - so the collection
      # that listens to this event has to.
      @model.set('ranked', -1)
  create_controls: ->
    # Add the ranking controls, so that only admins can see this.
    control_div = $('<div>').addClass('controls-box').addClass('active')
    up_div = $('<div>').attr('id', 'up').addClass('ranking-sign').text('+')
    down_div = $('<div>').attr('id', 'down').addClass('ranking-sign').text('-')

    margin_div = $('<div>').addClass('margin')
    control_div.append(margin_div)
    margin_div.append(up_div).append(down_div)
    
    delete_control = $('<div>').addClass('controls-box').addClass('active').addClass('right-margin')
    out_div = $('<div>').attr('id', 'out').addClass('ranking-sign').text('X')
    delete_control.append(out_div)

    return [control_div, delete_control]

  add_controls: (evt, inside_selector) ->
    if $(evt.target).hasClass(@top_container_class)
      container = $(evt.target)
    else
      container = $(evt.target).closest(@top_container_selector)
    container.addClass('showing-controls')
    container.closest(inside_selector).find('.controls-box').show({duration: 'medium'})

  remove_controls: (evt, inside_selector) ->
    if $(evt.target).hasClass(@top_container_class)
      container = $(evt.target)
    else
      container = $(evt.target).closest(@top_container_selector)
    container.removeClass('showing-controls')
    container.closest(inside_selector).find('.controls-box').hide()
