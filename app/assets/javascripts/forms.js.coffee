window.CmsModel = Backbone.Model.extend
  urlRoot: '/ajax_api?payload=cms/get/',
  getById: ->
    this.fetch
      success: (m, resp, opt) ->
        m.set(resp['data'])

window.cms_text = new CmsModel()
window.CmsList = Backbone.Collection.extend
  urlRoot: '/ajax_api?payload=cms/get/',
  url: ->
    return this.urlRoot + this.search_filter
  model: CmsModel,
  getById: ->
    this.fetch
      success: (coll, resp, opt) ->
        coll.set resp['data']
    
window.cms_list = new CmsList()
cms_list.search_filter = 'help_text'
cms_list.getById()

Controller = ->
Controller.prototype = 
  set_length : (elt) ->
    if $(elt).val().length > 10
      $(elt).siblings('.builder-before').css('background-color', 'green')
    else
      $(elt).siblings('.builder-before').css('background-color', 'white')
          
window.controller = new Controller()
  
set_prompt = (css_select) ->
  window.selector = css_select
  if window.prompt_map
    prompt = window.prompt_map['data'][$('#survey_question_question_type option:selected').text()]
    $(css_select).text prompt
  else
    $.post('/ajax_api',
        'payload' : 'survey_question/get_prompt_map/'
      (d, s, x) -> 
        window.prompt_map = d
        set_prompt(window.selector) # recursion
    )

functions = ->      
  set_prompt('#helper_edit')

  if $('.builder-box')
    $('.builder-box').each (idx, elt) ->
      id = $(elt).find('.hidden').data('box-id')
      new_elt = $('<div>').addClass('builder-before')
      new_elt.text id
      $(elt).prepend new_elt

      id = $(elt).find('.hidden').data('box-key')
    $('.builder-after').click (evt) ->
      help_box = $(this).closest('.builder-box').find('.help-text')
      id = $(this).closest('.builder-box').find('.hidden').data('box-key')
  
      if help_box.text() == ''
          help_box.text(window.cms_list.where({key: 'help_text_'+id})[0].get('cms_text'))
      help_box.toggle()
      
    $('#survey_question_question_type').change( (evt) ->
      set_prompt('#helper_edit')
    )

  $('.watched-box').keyup (evt) ->
    window.controller.set_length(this)
    
$(document).on('page:load ready', functions)

