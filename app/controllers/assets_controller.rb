class AssetsController < ApplicationController

	#GET /assets
	def index

		@assets = self.current_project.assets

		respond_to do |format|
			format.html
		end

	end

	#GET /assets/upload
	def new
		@asset = Asset.new

		respond_to do |format|
			format.html
		end
	end

	#POST /assets
	def create
		@asset = Asset.new(params[:asset])
		@asset.asset_object = self.current_project

		if @asset.save
			flash[:success] = 'File successfully uploaded'
		else
			flash[:error] = 'File upload error'
		end
		redirect_to :action => :index
	end

	#GET /asset/:id
	def show
		@asset = Asset.find_by_id(params[:id])
		if @asset.asset_object_type == "Project"
			if  @asset.asset_object_id == self.current_project.id
				object_key = @asset.file.to_s.split('/',5).last
				object_key = object_key.split('?').first
				s3_credentials = YAML.load_file("config/s3.yml")[Rails.env]
				s3 = AWS::S3.new
				s3_object = s3.buckets[s3_credentials["bucket"]].objects[object_key]
				url =  s3_object.url_for(:read, :expires => 60)
				redirect_to url.to_s
				return
			end
		end
		redirect_to :back
	end

end
