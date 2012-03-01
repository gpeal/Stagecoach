class ProjectsController < ApplicationController
  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.all

    @header = "Projects"
    respond_to do |format|
      format.mobile # index.html.erb
    end
  end

  def join
    @project = Project.find(params[:id])
    if params[:pass] == @project.password
        self.current_user.projects.push(@project)
        self.current_user.save
        self.current_project=(@project.id)
        respond_to do |format|
            format.mobile { redirect_to projects_path, notice: 'Joined Project Successfully.' }
        end

    else
      respond_to do |format|
        format.mobile { redirect_to projects_path, notice: 'Incorrect Password.'  }
      end
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @project = Project.find(params[:id])
    @people = @project.users.all
    respond_to do |format|
      format.mobile # show.html.erb
      format.json { render json: @project }
    end
  end

  # GET /projects/new
  # GET /projects/new.json
  def new
    @project = Project.new

    @header = "New Project"
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @project }
    end
  end

  # GET /projects/1/edit
  def edit
    @project = Project.find(params[:id])
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = current_user.projects.create(params[:project])
    respond_to do |format|
      if @project.save
        self.current_project=(@project.id)
        format.html { redirect_to projects_path, notice: 'Project was successfully created.' }
        format.mobile { redirect_to projects_path, notice: 'Project was successfully created.' }
        format.json { render json: projects_path, status: :created, location: @project }
      else
        format.html { render action: "new" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.json
  def update
    @project = Project.find(params[:id])

    respond_to do |format|
      if @project.update_attributes(params[:project])
        if current_project == @project
        self.current_project=(@project.id)
        end
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { head :no_content }
        format.mobile { redirect_to @project, notice: 'Project was successfully updated.' }
      else
        format.html { render action: "edit" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
        format.mobile { render action: "edit" }
      end
    end
  end

  def change_project
      if params[:project_id] == nil
        @new_project= Project.new(params[:project])
        @new_project.save
        @new_project.users << current_user
        self.current_project = @new_project
      else
        self.current_project= params[:project_id]
      end
      respond_to do |format|
        format.mobile {redirect_to projects_path(current_project)}
        format.html {redirect_to projects_path(current_project) }
        format.json {redirect_to projects_path(current_project)}
      end
    end


  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project = Project.find(params[:id])
    @project.destroy
    self.current_project=(current_user.projects.last)

    respond_to do |format|
      format.html { redirect_to projects_path }
      format.json { head :no_content }
      format.mobile { redirect_to projects_path }
    end
  end
end









