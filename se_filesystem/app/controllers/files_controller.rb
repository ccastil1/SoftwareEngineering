class FilesController < ApplicationController
  def show
    @file = SeFile.find_by(name: params[:name])
    render json: @file
  end
end
