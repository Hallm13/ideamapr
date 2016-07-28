class RespondentsController < ApplicationController
  # Special class to manage dummy respondents in prototype
  def reset
    status = false
    if request.xhr? and params[:auth_token]
      if Admin.find_by_auth_token params[:auth_token]
        Respondent.all.map &:mangle_cookie
        status = true
      end
    end
    render json: ({status: status})
  end
end
