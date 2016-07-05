set_prompt = (css_select) ->
  if window.prompt_map
    prompt = window.prompt_map['data'][$('#survey_question_question_type option:selected').val()]
    $(css_select).text prompt
  else
    $.post('/ajax_api',
        'payload' : 'survey_question/get_prompt_map/'
      (d, s, x) ->
        window.prompt_map = d
        set_prompt(css_select) # recursion
    )

sq_edit_functions = ->
  show_field_or_ideas = (qn_type) ->
    # qn_type is reqd to be an integer.
    
    if qn_type == 1 || qn_type == 3 || qn_type == 0
      $('[data-box-key=sq-add-ideas]').closest('.builder-box').show()
      $('[data-box-key=sq-add-fields]').closest('.builder-box').hide()
    else
      $('[data-box-key=sq-add-ideas]').closest('.builder-box').hide()
      $('[data-box-key=sq-add-fields]').closest('.builder-box').show()
      
  switch_qn_type = (switch_to) ->
    switch_to = parseInt switch_to
    show_field_or_ideas switch_to
    if switch_to == 5 || switch_to == 6
      $('#search-box').hide()
    if switch_to == 0 || switch_to == 1 || switch_to == 3
      # When choosing Budgeting type for questions show add'l controls
      $('#search-box').show()
      if switch_to == 3
        $('[data-box-key=sq-set-budget]').closest('.builder-box').show()
      else
        $('[data-box-key=sq-set-budget]').closest('.builder-box').hide()      
    null
      
  if ($.find('form#survey_question_new').length > 0 || $.find('form#survey_question_edit').length > 0) and \
      $.find('#survey_question_id').length > 0
    # We are creating or editing a survey qn
    qn_id = $('#survey_question_id').val()
    window.sq_model = new IdeaMapr.Models.SurveyQuestion()
    window.sq_model.set('id', qn_id)

    # New question type default is RANKING
    if qn_id == '0'
      window.sq_model.set('question_type', 1)
      new_survey_qn = true
      set_prompt '#helper-edit'
    else
      new_survey_qn = false
      window.sq_model.set 'question_type', parseInt($('#saved_question_type').val())

    question_type = window.sq_model.get('question_type')
    switch_qn_type question_type
    
    # For new survey qns, init all Backbone apps
    # The populate_data() calls will trigger a sync event that renders the appropriate view
    if new_survey_qn || question_type == 5 || question_type == 6
      window.sq_model.set_field_details()
      window.field_details_view = new IdeaMapr.Views.AdminDetailsCollectionView
        model: window.sq_model
        el: '#fields-list-app'
        
      if new_survey_qn
        window.sq_model.set('question_type', 5)
      window.field_details_view.populate_data()

    if new_survey_qn || question_type == 1 || question_type == 3 || question_type == 0
      window.sq_model.set_idea_list()
      window.idea_lists_view = new IdeaMapr.Views.AdminIdeaCollectionsView
        model: window.sq_model
      window.idea_lists_view.populate_data()

    $('#survey_question_question_type').change (evt) ->
      # When the question type is changed, on new views
      switch_qn_type $(evt.target).val()
      set_prompt('#helper-edit')

    $('#object-save').click (evt) ->
      # Gather the collected fields or ideas models for unpacking by the controller
      # Validate all the text boxes
      
      if window.run_validations()
        # Question type is saved in diff fields for new and for existing survey qns
        qt = window.sq_model.get('question_type')
        qd_elt = $('<input type=hidden>').attr('name', 'question_details')
        json_str = JSON.stringify(window.sq_model.component_data())
        qd_elt.val json_str
        $(evt.target).closest('form').append qd_elt
        true
      else
        evt.stopPropagation()
        false
      
$(document).on('ready page:load', sq_edit_functions)
