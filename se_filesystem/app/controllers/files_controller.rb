class FilesController < ApplicationController
  def show
    @file = SeFile.find(params[:id])
    render json: @file
  end
end
