set_prompt = (css_select) ->
  if window.prompt_map
    prompt = window.prompt_map['data'][window.sq_model.get('question_type')]
    $(css_select).text prompt
  else
    $.post('/ajax_api',
        'payload' : 'survey_question/get_prompt_map/'
      (d, s, x) ->
        window.prompt_map = d
        set_prompt(css_select) # recursion
    )

sq_edit_functions = ->
  window.unassigned_closer()
  show_field_or_ideas = (qn_type) ->
    # qn_type is reqd to be an integer.
    
    if qn_type == 1 || qn_type == 3 || qn_type == 0 || qn_type == 4
      window.idea_lists_view.render()
      $('[data-box-key=sq-add-ideas]').closest('.builder-box').show()
      $('[data-box-key=sq-add-fields]').closest('.builder-box').hide()
    else if qn_type == 5 || qn_type == 6
      window.field_details_view.render()
      $('[data-box-key=sq-add-ideas]').closest('.builder-box').hide()
      $('[data-box-key=sq-add-fields]').closest('.builder-box').show()
    else 
      $('[data-box-key=sq-add-ideas]').closest('.builder-box').hide()
      $('[data-box-key=sq-add-fields]').closest('.builder-box').hide()
      
  switch_qn_type = (switch_to) ->
    switch_to = parseInt switch_to
    window.sq_model.set('question_type', switch_to)
    
    show_field_or_ideas switch_to
    if switch_to == 5 || switch_to == 6
      $('#search-box').hide()
    if switch_to == 0 || switch_to == 1 || switch_to == 3 || switch_to == 4
      # When choosing Budgeting type for questions show add'l controls
      $('#search-box').show()
      if switch_to == 3
        $('[data-box-key=sq-set-budget]').closest('.builder-box').show()
      else
        $('[data-box-key=sq-set-budget]').closest('.builder-box').hide()
    if switch_to == 2
      $('[data-box-key=sq-new-idea]').closest('.builder-box').show()
    else
      $('[data-box-key=sq-new-idea]').closest('.builder-box').hide()      
    null

  # Set up events
  $('#survey_question_question_type').change (evt) ->
    # When the question type is changed, on new views
    switch_qn_type $(evt.target).val()
    set_prompt('#helper-edit')

  # Run the logic for this page.
  if ($.find('form#survey_question_new').length > 0 || $.find('form#survey_question_edit').length > 0) and \
      $.find('#survey_question_id').length > 0

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
      
    # We are creating or editing a survey qn
    qn_id = $('#survey_question_id').val()
    window.sq_model = new IdeaMapr.Models.SurveyQuestion()
    window.sq_model.set('id', qn_id)
    # New question type default is RANKING
    if qn_id == '0'
      window.sq_model.set('question_type', 1)
      new_survey_qn = true
    else
      new_survey_qn = false
      window.sq_model.set 'question_type', parseInt($('#saved_question_type').val())

    # This has to be here, after the sq model's question type has been set.
    set_prompt '#helper-edit'
    question_type = window.sq_model.get('question_type')
    # For new survey qns, init all Backbone apps
    # The trigger_fetches() calls will trigger a sync event that renders the appropriate view
    if new_survey_qn || question_type == 5 || question_type == 6
      details_list = window.sq_model.set_field_details()
      window.field_details_view = new IdeaMapr.Views.AdminDetailsCollectionView
        model: window.sq_model
        el: '#fields-list-app'

    if new_survey_qn || question_type == 1 || question_type == 3 || question_type == 0 || question_type == 4
      idea_list = window.sq_model.set_idea_list()
      window.idea_lists_view = new IdeaMapr.Views.AdminIdeaCollectionsView
        model: window.sq_model
        el: '#idea-list-app'
    unless question_type == 2
      window.sq_model.trigger_fetches()

    switch_qn_type question_type
    
$(document).on('turbolinks:load', sq_edit_functions)
