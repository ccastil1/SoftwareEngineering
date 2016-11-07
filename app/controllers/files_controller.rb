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

  def upload
    outputstr = "success: File " + params[:name] + " successfully uploaded!"
    statusval = 200

    #If file already exists in database, update it
    if SeFile.exists?(name: params[:name])
      @file = SeFile.find_by(name: params[:name])
      @file.attachment = params[:data]
      @file.save

      outputstr = "success: File " + params[:name] + " successfully uploaded!"

    else #If file doesn't exist in database, create it

      #Create a new SeFile instance and add it to the database
      @file = SeFile.new(name: params[:name])
      @file.attachment = params[:data]
      @file.save

    end

    #Raise exception if file is not created

    if not SeFile.exists?(name: params[:name])
      #Change output string and raise error
      outputstr = "failure: File " + params[:name] + "was not uploaded!"
      statusval = 500
    end

    #output message and status
    output = { :message => outputstr }
    render :json => output, :status => statusval
  end
end
