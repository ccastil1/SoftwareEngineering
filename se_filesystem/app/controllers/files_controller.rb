class FilesController < ApplicationController
  def list
    @file = SeFile.all
    render :json => @file
  end

  def show
    @file = SeFile.find_by(name: params[:name])
    render json: @file
  end
  
  def upload

    #Need to make sure it will not overwrite if user does not have access


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
