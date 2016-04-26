module SurveysHelper
  def public_link_display(s)
    if Survey::SurveyStatus.name(s.status) == 'Published'
      link_to (public_show_survey_url(s).gsub(/\?locale=../, ''))[0..25]+'...',
              public_show_survey_url(public_link: s.public_link)
    else
      'Not Public'
    end
  end
end
