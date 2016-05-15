unless s = SurveyQuestion.find_by_title('Demographic question sample')
  s = SurveyQuestion.new question_type: SurveyQuestion::QuestionType::RADIO_CHOICES,
                         title: 'Demographic question sample',
                         question_prompt: 'Select your demographic'
  s.save
end

unless s.question_detail
  qd = QuestionDetail.new details_list: ['Asian', 'African-American', 'White']
  qd.survey_question = s
  qd.save
end

