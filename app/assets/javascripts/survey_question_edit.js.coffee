functions = ->
  switch_qn_type = (switch_to) ->
    if switch_to == '5' || switch_to == '6'
      if window.hasOwnProperty('field_details')
        window.data_container = window.field_details
        window.field_details.set_question_type switch_to
        window.field_details.render()
      else
        alert('hey! cannot find field list app. :(')
    if switch_to == '0' || switch_to == '1' || switch_to == '3'
      if window.hasOwnProperty('idea_list')
        window.data_container = window.idea_list
        window.idea_list.set_question_type switch_to
        window.idea_list.render()
      else
        alert('hey! cannot find idea list app. :(')
      
  if $('form#container_update') and $('#survey_question_id')
    # We are creating or editing a survey qn
    qn_id = $('#survey_question_id').val()

    # If it's a new survey its default qn type is ranking (1)
    if typeof $('#saved_question_type').val() == 'undefined'
      new_survey = true
      qn_type = 1
    else
      new_survey = false
      qn_type = $('#saved_question_type').val()

    # For new surveys, init all Backbone apps
    if new_survey || qn_type == '5' || qn_type == '6'
      coll = new IdeaMapr.Collections.DetailsCollection()
      coll.question_id = qn_id
      
      window.field_details = new IdeaMapr.Views.SurveyQuestionDetailsView
        collection: coll
        el: $('#fields-list-app')

      # This set the type for the view and its collection
      window.field_details.set_question_type qn_type
      window.data_container = window.field_details
      coll.fetch()
      
    if new_survey || qn_type == '1' || qn_type == '3' || qn_type == '0'
      ideas = new IdeaMapr.Collections.IdeaCollection()
      ideas.survey_question_id = qn_id
      window.idea_list = new IdeaMapr.Views.IdeaManager
        collection: ideas
        el: $('#idea-list-app')
      window.data_container = window.idea_list

      # This sets the type for both the assigned and search views in one go
      window.idea_list.set_question_type qn_type
      ideas.fetch()

    $('#survey_question_question_type').change (evt) ->
      # When the question type is changed, on new views
      switch_qn_type $(evt.target).val()
      
    $('#survey_question_question_type').change( (evt) ->
      window.set_prompt('#helper_edit')

      $('#survey_question_question_prompt').val('')
      # When choosing Budgeting type for questions show add'l controls
      if $(evt.target).val() == '3'
        $('[data-box-key=sq-set-budget]').closest('.builder-box').show()
      else
        $('[data-box-key=sq-set-budget]').closest('.builder-box').hide()

      # When choosing non idea question type, the Backbone app box should become visible

      dyn_comp_word_elt = $('#component-word')
      if $(evt.target).val() == '5' or $(evt.target).val() == '6'
        $('[data-box-key=sq-add-fields]').closest('.builder-box').show()
        $('[data-box-key=sq-add-ideas]').closest('.builder-box').hide()
        dyn_comp_word_elt.val('Save and Add Fields')
      else
        $('[data-box-key=sq-add-fields]').closest('.builder-box').hide()
        $('[data-box-key=sq-add-ideas]').closest('.builder-box').show()
        dyn_comp_word_elt.val('Save and Add Ideas')
      
    )

    $('#survey-question-save').click (evt) ->
      # Gather the collected fields or ideas models for unpacking by the controller

      # Question type is saved in diff fields for new and for existing survey qns
      qt = (if (typeof $('#survey_question_question_type').val() == 'undefined') then $('#saved_question_type').val() else
        $('#survey_question_question_type').val())        
      qd_elt = $('<input type=hidden>').attr('name', 'question_details')
      
      json_str = JSON.stringify(window.data_container.serialize_models())
      qd_elt.val json_str
      $('form#container_update').append qd_elt
      true
      
$(document).on('ready page:load', functions)
