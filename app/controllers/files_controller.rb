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

    @file = SeFile.find_by(name: params[:name])
    if @file == nil
      output = { :message => "failure" }
      render :json => output
      return
    end

    ActiveRecord::Base.transaction do
      # Remove entry from database    
      @file.delete
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
