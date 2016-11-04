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

    #If file already exists in database, update it
    if SeFile.exists?(name: params[:name])

      @file = SeFile.find_by(name: params[:name])
      @file.update_attribute(:updated_at, DateTime.now)
      #write to file
      File.open("../" + params[:name],"wb") do |f|
        f << params[:data].read
      end
      render :text => "File Updated"

    else #If file doesn't exist in database, create it

      @file = SeFile.new(name: params[:name])
      if @file.save
        #write to file
        File.open("../" + params[:name],"wb") do |f|
          f << params[:data].read
        end
        render :text => "File Created"
      else
        render :text => "File not uploaded."
      end

    end
  end
end
