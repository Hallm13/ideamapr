IdeaMapr.Views.SurveyView = Backbone.View.extend
  className: 'row',
  initialize: ->
    _.bindAll(this, 'render')
  events:
    'click #status-change-dropdown': (evt) ->
      this.$('.dd-choice-list').toggle()
      this
    'click .dd-choice': (evt) ->
      evt.stopPropagation()
      this.model.save
        displayed_survey_status: $(evt.target).data('label')
        
      this.render()
      this    
      
  render: ->
    this.$el.html(_.template($('#survey-listing-template').html())(this.model.attributes))
    show_list = _.difference(_.keys(this.allowed_list), [this.model.get('displayed_survey_status')])

    view_self = this
    dd_container = $('<div>').addClass('dd-choice-list')
    view_self.$('#status-change-dropdown').append dd_container    
    show_list.forEach (label, idx) ->
      dd_container.append($('<div>').addClass('dd-choice').data('label', label).text(label))
    this
    
  set_dropdown_choices: (allowed_list) ->
    this.allowed_list = allowed_list
    
      
