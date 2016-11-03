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
    #@file = SeFile.new(name: params[:name])
    File.open("../" + params[:name],"w") do |f|
      f.write(params[:data])
    end
     render :text => "Success"
  end
end
