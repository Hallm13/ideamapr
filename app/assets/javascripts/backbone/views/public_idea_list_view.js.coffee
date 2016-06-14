IdeaMapr.Views.PublicIdeaListView = IdeaMapr.Views.IdeaListView.extend
  initialize: ->
    _.bindAll(@, 'render')
    @
    
  events:
    'click #save-response': ->
      qn_response = @collection.map (m) ->
        m.response_data()
        
      url = '/individual_answers'

      d={}
      d['survey_token'] = @collection.survey_token
      d['sqn_id'] = @collection.sqn_id
      d['response_data'] = JSON.stringify({data: qn_response})
      $.post url, d, (d, s, x) ->
        alert(JSON.stringify(d))
      
  render: ->
    viewself = @
    # clear!
    @$el.html ''
    @collection.each (m) ->
      child_view = new IdeaMapr.Views.PublicIdeaView
        model: m
      child_view.question_type = viewself.question_type
      viewself.$el.append(child_view.render().el)

    save_button = $('<button>').attr('id', 'save-response').addClass('col-xs-12').text('Save Response')
    @$el.append save_button

    @
