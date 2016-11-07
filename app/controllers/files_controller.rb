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
    successstr = "failure: File " + params[:name] + "does not exist in server database!" 
    statusval = 400

    file = SeFile.find_by(name: params[:name])
    if file.nil?
      output = { :message => successstr }
      render :json => output, :status => statusval
      return
    end

    # Remove entry from database and delete file
    file.delete

    successstr = "success: File " + params[:name] + " successfully deleted!"
    statusval = 200

    # Respond with success appropriately
    output = { :message => successstr }
    render :json => output, :status => statusval
  end
end
