IdeaMapr.Models.SurveyQuestion = Backbone.Model.extend
  defaults: ->
    answered: false
  urlRoot: '/survey_question',
    
  getResponseData: ->
    obj =
      sqn_id: this.get('id')
    obj['answers'] =
      this.idea_list.map (elt, idx) ->
        elt.getResponseData()
    obj
