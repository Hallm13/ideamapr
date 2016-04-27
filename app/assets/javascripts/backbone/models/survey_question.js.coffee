IdeaMapr.Models.SurveyQuestion = Backbone.Model.extend
  defaults: ->
  urlRoot: '/survey_question',

  initialize: ->
  setIdeaList: (master_list) ->
    # start here: http://stackoverflow.com/questions/8596999/how-to-clone-a-backbone-collection

    this.idea_list = new IdeaMapr.Collections.IdeaCollection()
    il = this.idea_list
    self = this
    master_list.each (orig_model) ->
      cloned_idea = new IdeaMapr.Models.Idea(orig_model.toJSON())
      cloned_idea.set_question_type self.get('question_type')
      
      il.add cloned_idea 
      
    this
    
  getResponseData: ->
    obj =
      sqn_id: this.get('id')
    obj['answers'] =
      this.idea_list.map (elt, idx) ->
        elt.getResponseData()
    obj
