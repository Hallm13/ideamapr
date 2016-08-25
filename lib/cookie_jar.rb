module CookieJar
  class CookieKey
    attr_reader :key
    attr_accessor :respondent_id
    def initialize(key:, new:, respondent_id:)
      @new = new
      @key = key
      @respondent_id = respondent_id
    end
    def new?
      @new
    end
  end
      
  def find_or_create_cookie(old_key = nil)
    # If a cookie key is passed in by the view, or the cookie's already set, don't create a new Respondent.
    # Return the key created or present.

    r = c = nil
    key = old_key.present? ? old_key : (c = cookies['_ideamapr_response_key'])
    just_created = false
    
    unless (r = Respondent.find_by_cookie_key key)
      # If the above call returns nil even when there is a key, let's assume a DBA deleted the respondent to start them afresh.
      r = Respondent.new cookie_key: key, ip_address: request.remote_ip
      r.save
      just_created = true
      
      cookies['_ideamapr_response_key'] = {value: r.cookie_key, expires: Time.now + 1.year}
    end

    Rails.logger.debug ">>> #{r.id}, #{r.created_at}"
    
    c=CookieKey.new key: r.cookie_key, new: just_created, respondent_id: r.id
    c
  end
end
