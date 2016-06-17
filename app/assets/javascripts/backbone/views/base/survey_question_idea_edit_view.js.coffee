IdeaMapr.Views.SurveyQuestionIdeaEditView = Backbone.View.extend
  base_events:
    'click #up': (evt) ->
      @model.set('ranked', 1)
    'click #down': (evt) ->
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
