t = Idea.viewbox_list + SurveyQuestion.viewbox_list

xmap = t.map do |vb|
  ["help_text_#{vb.box_key}", (vb.help_text || 'No help text available.')]
end.inject({}) do |memo, pair|
  memo[pair[0]] = pair[1]
  memo
end

# Surveys
content = {
  'help_text_survey-create-title' => '',
  'help_text_survey-create-intro' => 'Add an intro for your survey',
  'help_text_survey-create-status' => 'You can update the status after you have added questions.',
  'help_text_survey-thankyou-note' => 'Add a Thank You note for respondents.' 
}

# Survey questions
content.merge({
  'help_text-sq-title' => 'Add a title for this question.',
  'help_text-sq-question-type' => 'The question type decides how ideas are shown to respondents and how they are reported back to you.'
})

xmap.each do |k, v|
  c = CmsContent.find_or_create_by key: k
  c.update_attributes cms_text: v
end
