# Actions for lists of things
window.lists_functions = ->
  $('.question-data .x-box').click (evt) ->
    parent = $(evt.target).closest '.question-data'
    id = parent.data('object-id')
    type = parent.data('object-type')
    evt.stopPropagation()

    response = confirm 'Delete this ' + type + ': Are you sure?'
    if response
      $.post('/ajax_api',
          payload: type + '/destroy/' + id,
        (d, s, x) ->
          # Either we remove an idea or a question/survey. That's just the way the CSS
          # cookie crumbled. :(
          
          unless (detach = parent.closest('.idea-row')).length > 0
            detach = parent.closest('.question-row')
          detach.detach()
      )

$(document).on('turbolinks:load', window.lists_functions)
