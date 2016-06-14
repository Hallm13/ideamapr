IdeaMapr.Models.SurveyQuestion = Backbone.Model.extend
  defaults: ->
    answered: false
    promoted: 0
    
  urlRoot: '/survey_question',
    
  make_example: ->
  getResponseData: ->
    obj =
      sqn_id: this.get('id')
    obj['answers'] =
      this.idea_list.map (elt, idx) ->
        elt.getResponseData()
    obj
