keys = ['help_text_survey-create-title', 'help_text_survey-create-intro', 'help_text_survey-create-status']

content = {
  'help_text_survey-create-title' => 'Add a title for your survey',
  'help_text_survey-create-intro' => 'Add an intro for your survey',
  'help_text_survey-create-status' => 'You can update the status after you have added questions.',
  'help_text_survey-thankyou-note' => 'Add a Thank You note for respondents.' 
}

keys.each do |k|
  c = CmsContent.find_or_create_by key: k
  c.update_attributes cms_text: content[k]
end
