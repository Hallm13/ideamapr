# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
	$(':text').keyup( (eventObject) -> 
		textEntered=$('#task_title').val()
		if textEntered.match(/^\s*\!/) != null 
			$('#help_message').show()
		else
			$('#help_message').hide()

		undefined
	)

# Hide the help message at the beginning
$ ->
	$('#help_message').hide()
