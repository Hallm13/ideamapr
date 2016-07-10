module CookieJar
  def find_or_create_cookie(old_key = nil)
    # If a cookie key is passed in by the view, or the cookie's already set, don't
    # create a new Respondent.
    # Return the key created or present.
    
    unless (key = old_key).present? || cookies['_ideamapr_response_key']
      key = Respondent.create.cookie_key
      cookies['_ideamapr_response_key'] = {value: key, expires: Time.now + 1.year}
    end
    
    key
  end
end
