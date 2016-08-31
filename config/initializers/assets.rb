IdeaMapr::Application.configure do
  config.assets.precompile << /\.(?:svg|eot|woff|ttf)\z/
  config.assets.precompile << %w( application_public.css )
  config.assets.precompile << %w( application.js )  
  config.assets.precompile << %w( application_public.js )
  config.assets.precompile << %w( idea_list.js )
  config.assets.precompile << %w( jquery.geocomplete.min.js )
end
