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
