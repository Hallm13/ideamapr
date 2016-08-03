IdeaMapr::Application.configure do
  config.assets.precompile << /\.(?:svg|eot|woff|ttf)\z/
  config.assets.precompile << %w( application_public.css )
  config.assets.precompile << %w( application_public.js )
  config.assets.precompile << %w( file_upload_manipulation.js )
end

