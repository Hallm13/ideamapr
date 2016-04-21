module CookieJar
  def find_or_create_cookie(old_key)
    unless (key = old_key || cookies['_ideamapr_response_key'])
      key = Respondent.create.cookie_key
      cookies['_ideamapr_response_key'] = key
    end
    
    key
  end
end
