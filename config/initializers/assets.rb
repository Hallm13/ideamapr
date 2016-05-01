IdeaMapr::Application.configure do
  config.assets.precompile << /\.(?:svg|eot|woff|ttf)\z/
  config.assets.precompile << %w(survey_index_app.js)
end

