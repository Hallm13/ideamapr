class AjaxController < ApplicationController
  def multiplex
    if request.xhr?
      # Implement this ajax library to return true iff the action is
      # found in a dictionary, and its db action succeeded
      status_struct = Ajax::Library.route_action(params[:payload])
      if status_struct[:status]
        render json: ({status: 'success'}).merge({request: params[:payload], data: status_struct[:data]}),
               layout: nil
      else
        render json: ({status: 'error'}).merge({request: params[:payload], mesg: status_struct[:error]}),
               layout: nil
      end
    end
  end
end
