class FilesController < ApplicationController
  protect_from_forgery with: :null_session
  def list
    @file = SeFile.all
    render :json => @file
  end

  def show
    @file = SeFile.find_by(name: params[:name])
    render json: @file
  end

  def remove
    successstr = "success"

    ActiveRecord::Base.transaction do
      # Remove entry from database    
      @file = SeFile.find_by(name: params[:name])
      if @file == nil
        successstr = "failure"
      else
        @file.delete
      end
      # Remove file
      File.delete("/var/lib/se_app/" + params[:name]) if File.exist?("/var/lib/se_app/" + params[:name])

      if File.exist?("/var/lib/se_app" + params[:name])
        # Raise file exception if delete fails
        successstr = "failure"
        raise Errno::ENOENT
      end
    end

    # Respond with success appropriately
    output = { :message => successstr }
    render :json => output
  end
end
