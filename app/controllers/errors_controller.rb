class ErrorsController < ApplicationController
  def status_404
    render_not_found and return
  end

  def status_500
    render_error and return
  end

end
