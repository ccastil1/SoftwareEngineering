class FileNodeFilesController < ApplicationController
  def list
    if Rails.env.file_node?
      @file = SeFile.all
      render json: @file
    end
  end

  def show
    if Rails.env.file_node?
      @file = SeFile.find_by(name: params[:name])
      if @file.nil?
        render json: { message: "File #{params[:name]} not found" }, status: 400
      else
        render json: @file
      end
    end
  end

  def download
    if Rails.env.file_node?
      file = SeFile.find_by name: params[:name]
      if file.nil?
        render json: { message: "File #{params[:name]} not found" }, status: 400
      else
        send_file file.attachment.path
      end
    end
  end
end
