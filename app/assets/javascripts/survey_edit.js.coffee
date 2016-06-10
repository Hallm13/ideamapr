functions = ->
  if ($.find('form#survey_new').length > 0 || $.find('form#survey_edit').length > 0) and $.find('#survey_id').length > 0
    # We are creating or editing a survey qn
    survey_id = $('#survey_id').val()

    # Init Backbone apps
    questions = new IdeaMapr.Collections.SurveyQuestionCollection()
    questions.survey_id = survey_id
    window.sq_list = new IdeaMapr.Views.SurveyQuestionsManager
      collection: questions
      el: $('#question-list-app')
    window.data_container = window.sq_list

    # This sets the type for both the assigned and search views in one go
    questions.fetch()
      
    $('#object-save').click (evt) ->
      # Gather the collected questions and validate all the text boxes
      
      if window.run_validations()
        # Question type is saved in diff fields for new and for existing survey qns
        qd_elt = $('<input type=hidden>').attr('name', 'question_list')
        
        json_str = JSON.stringify(window.data_container.serialize_models())
        qd_elt.val json_str
        $(evt.target).closest('form').append qd_elt
        true
      else
        evt.stopPropagation()
        false
      
$(document).on('ready page:load', functions)
