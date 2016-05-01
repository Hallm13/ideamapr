IdeaMapr.Models.Survey = Backbone.Model.extend
  defaults: ->
  rendering_data: ->
    title: this.get('title')
    survey_show_url: this.get('survey_show_url')
    survey_edit_url: this.get('survey_edit_url')    
    displayed_survey_status: 'DRAFT'
