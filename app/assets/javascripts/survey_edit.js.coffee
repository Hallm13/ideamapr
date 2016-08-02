functions = ->
  if ($.find('form#survey_new').length > 0 || $.find('form#survey_edit').length > 0) and $.find('#survey_id').length > 0
    # We are creating or editing a survey qn
    window.survey_model = new IdeaMapr.Models.Survey()
    window.survey_model.set('id', $('#survey_id').val())
    questions = new IdeaMapr.Collections.SurveyQuestionCollection()

    window.survey_model.questions = questions
    questions.survey_token = window.survey_model.get('id')

    # The view will trigger a fetch that will need to know this property exists.
    window.survey_model.questions = questions
    
    sq_list_view = new IdeaMapr.Views.SurveyQuestionsManager
      model: window.survey_model
      collection: questions
      el: $('#question-list-app')
    sq_list_view.populate_data()
      
    $('#object-save').click (evt) ->
      # Gather the collected questions and validate all the text boxes
      # Validate all the text boxes
      if window.run_validations()
        # Question type is saved in diff fields for new and for existing survey qns
        qd_elt = $('<input type=hidden>').attr('name', 'survey_details')
        
        json_str = JSON.stringify(window.survey_model.component_data())
        qd_elt.val json_str
        $(evt.target).closest('form').append qd_elt
        true
      else
        evt.stopPropagation()
        false
      
$(document).on('ready turbolinks:load', functions)
