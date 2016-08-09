module SurveysHelper
  def public_status_display(s)
    if Survey::SurveyStatus.name(s.status) == 'Published'
      link_to 'Published',
              public_show_surveys_url(public_link: s.public_link)
    else
      Survey::SurveyStatus.name(s.status)
    end
  end

  def status_as_word(id)
    Survey::SurveyStatus.name id
  end

  def as_percentage(float)
    sprintf("%0.2f", float * 100) + '%'
  end
  def as_dollar(float)
    sprintf("$%0.2f", float)
  end  
end
