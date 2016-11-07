class FilesController < ApplicationController
  protect_from_forgery with: :null_session
  def list
    @file = SeFile.all
    render :json => @file
  end

  def show
    @file = SeFile.find_by(name: params[:name])
    if @file.nil?
      render json: { message: "File #{params[:name]} not found" }, status: 400
    else
      render json: @file
    end
  end

  def download
    file = SeFile.find_by name: params[:name]
    if file.nil?
      render json: { message: "File #{params[:name]} not found" }, status: 400
    else
      send_file file.attachment.path
    end
  end

  def remove
    successstr = "success: File " + params[:name] + " successfully deleted!"
    statusval = 200

    @file = SeFile.find_by(name: params[:name])
    if @file == nil
      statusval = 500
      output = { :message => "failure: File " + params[:name] + "does not exist in server database!" }
      render :json => output, :status => statusval
      return
    end

    ActiveRecord::Base.transaction do
      # Remove entry from database
      @file.delete
      # Remove file
      File.delete("/var/lib/se_app/" + params[:name]) if File.exist?("/var/lib/se_app/" + params[:name])

      if File.exist?("/var/lib/se_app" + params[:name])
        # Raise file exception if delete fails
        successstr = "failure: File " + params[:name] + " does not exist on server!"
        statusval = 500
        raise Errno::ENOENT
      end
    end

    # Respond with success appropriately
    output = { :message => successstr }
    render :json => output, :status => statusval
  end
end
