module CookieJar
  class CookieKey
    attr_reader :key
    attr_accessor :respondent_id
    def initialize(key:, new:)
      @new = new
      @key = key
    end
    def new?
      @new
    end
  end
      
  def find_or_create_cookie(old_key = nil)
    # If a cookie key is passed in by the view, or the cookie's already set, don't
    # create a new Respondent.
    # Return the key created or present.

    r = c = nil
    key = old_key.present? ? old_key : (c = cookies['_ideamapr_response_key'])
    if key.present?
      just_created = false
      if c
        # We have to check if this respondent has already closed their survey.
        # If this call returns nil, let's assume a DBA deleted the respondent, so they get to start afresh.
        r = Respondent.find_by_cookie_key c
      end
    else
      key = (r=Respondent.create).cookie_key
      cookies['_ideamapr_response_key'] = {value: key, expires: Time.now + 1.year}
      just_created = true
    end

    unless r
      # A DBA might have deleted the respondent even though the cookie was set
      # This is going to be such a pain to test-cover. :(
      r = Respondent.create cookie_key: key
      just_created = true
    end
    c=CookieKey.new key: key, new: just_created
    if r
      c.respondent_id = r.id
    end

    c
  end
end
