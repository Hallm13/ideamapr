module SurveysHelper
  def public_status_display(s)
    if Survey::SurveyStatus.name(s.status) == 'Published'
      link_to 'Published',
              public_show_surveys_url(public_link: s.public_link)
    else
      Survey::SurveyStatus.name(s.status)
    end
  end
end
