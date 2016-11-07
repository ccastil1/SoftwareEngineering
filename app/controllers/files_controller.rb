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
      @file.update_attribute(:updated_at, DateTime.now)

      #Replace the body of the file
      File.open("/var/lib/se_app/" + params[:name],"wb") do |f|
        f << params[:data].read
      end
      render :text => "File Updated"

    else #If file doesn't exist in database, create it

      ActiveRecord::Base.transaction do
        #Create a new SeFile instance and add it to the database
        @file = SeFile.new(name: params[:name])
        @file.save

        #Create the file 
        File.open("/var/lib/se_app/" + params[:name],"wb") do |f|
          f << params[:data].read
        end

        #Raise exception if file is not created
	if not File.exist?("/var/lib/se_app/" + params[:name])
	  #Change output string and raise error
	  outputstr = "failure: File " + params[:name] + "was not created!"
	  statusval = 500
	  raise Errno::ENOENT
	end
      end

      #output message and status
      output = { :message => outputstr }
      render :json => output, :status => statusval
    end
  end
end
