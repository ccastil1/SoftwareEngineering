class FilesController < ApplicationController
  def list
    @file = SeFile.all
    render :json => @file
  end

  def show
    @file = SeFile.find_by(name: params[:name])
    render json: @file
  end

  def remove
    @file = SeFile.find_by(name: params[:name])
    @file.delete
    output = { :message => "success" }
    render :json => output
  end
end
