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
      node = FileNode.all.sample
      redirect_to "#{node.url}/file_node_files/download/#{file.name}"
      status_code = 200
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
    system("~/replicateDB.sh")
    output = { :message => successstr }
    render :json => output, :status => statusval
  end

  def post_params
    params.require(:se_file).permit(:name, :attachment)
  end

  def upload
    uploaded_file = SeFile.new post_params
    file_name = uploaded_file.name
    uploaded_file.save

    if post_params[:attachment].nil? || post_params[:attachment].size.zero?
      status_code = 400
      message = 'Upload failure: File attachment cannot be empty.'
    elsif post_params[:name].blank?
      status_code = 400
      message = 'Upload failure: Filename cannot be empty.'
    elsif !uploaded_file.errors.empty?
      status_code = 400
      message = uploaded_file.errors.full_messages
    else
      FileNode.all.each do |node|
        url = node.url + '/files'
        RestClient.post(
          url,
          'se_file[name]' => file_name,
          'se_file[attachment]' => open(uploaded_file.attachment.path)
        )
        node.se_files.append uploaded_file
      end
      message = "Upload success: File #{file_name} successfully uploaded!"
      status_code = 200
    end

    render json: { message: message }, status: status_code
  end
end
