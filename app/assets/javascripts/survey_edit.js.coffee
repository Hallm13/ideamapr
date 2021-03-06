functions = ->
  if ($.find('form#survey_new').length > 0 || $.find('form#survey_edit').length > 0) and $.find('#survey_id').length > 0
    # set up the dropdown behavior
    # I think both ready and turbolinks:load are firing on this page... that's why the off() is necessary
    
    window.unassigned_closer()
    $('#status-change-dropdown .cell-1').off().click (evt) ->
      $('.dd-choice-list').toggle()
      evt.stopPropagation()

    $('#public-link a').click (e) ->
      if $(e.target).attr('href') == '#'
        return false
      else
        return true
        
    $('.dd-choice').click (evt) ->
      evt.stopPropagation()
      status = $(evt.target).data('status-key')
      txt = $(evt.target).text()      
      $('input#survey_status').val status
      $('#status-change-dropdown .shown-text').text txt
      if status == 1
        # Published; show the public link
        $('#public-link a').attr 'href', $('#hidden_public_link').val()
        $('#public-link a').text $('#hidden_public_link').val()
      else
        $('#public-link a').text 'Not published'
        $('#public-link a').attr 'href', '#'
      
      $('.dd-choice-list').hide()

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
    window.survey_model.trigger_fetches()
      
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
      
$(document).on('turbolinks:load', functions)
