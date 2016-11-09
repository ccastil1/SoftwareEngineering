class WelcomeController < ApplicationController
  def index
        @files = SeFile.all
        @newFile = SeFile.new
  end

def show
  @file = SeFile.find(params[:id])

  respond_to do |format|
    format.html # show.html.erb
    format.xml  { render :xml => @file }
  end
end

def destroy
    successstr = "failure: File " + params[:name] + " does not exist in server database!" 
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
    output = { :message => successstr }
    render :json => output, :status => statusval
  end
end


def create
  @file = SeFile.new(params[:name])
  puts params
  respond_to do |format|
    if @file.save
      flash[:notice] = 'File was successfully uploaded.'
      format.html { redirect_to(@file) }
      format.xml  { render :xml => @file, :status => :created,
	                :location => @file }
    else
      format.html { render :action => "new" }
      format.xml  { render :xml => @file.errors,
	                :status => :unprocessable_entity }
    end
  end
end

def download
    file = SeFile.find_by name: params[:name]
    if file.nil?
      render json: { message: "File #{params[:name]} not found" }, status: 400
    else
      send_file file.attachment.path
      flash[:notice] = 'File was successfully uploaded.'
    end
end