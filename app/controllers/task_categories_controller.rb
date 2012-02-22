class TaskCategoriesController < ApplicationController
  # GET /task_categories
  # GET /task_categories.json
  def index
    @task_categories = self.current_project.task_categories.all

    respond_to do |format|
      format.mobile # index.html.erb
      format.json { render json: @task_categories }
    end
  end

  # GET /task_categories/1
  # GET /task_categories/1.json
  def show
    @task_category = TaskCategory.find(params[:id])

    respond_to do |format|
      format.mobile # show.html.erb
      format.json { render json: @task_category }
    end
  end

  # GET /task_categories/new
  # GET /task_categories/new.json
  def new
    @task_category = TaskCategory.new

    respond_to do |format|
      format.mobile # new.html.erb
      format.json { render json: @task_category }
    end
  end

  # GET /task_categories/1/edit
  def edit
    @task_category = TaskCategory.find(params[:id])
  end

  # POST /task_categories
  # POST /task_categories.json
  def create
    @task_category = TaskCategory.new(params[:task_category])
    setDefaults @task_category
    @task_category.save

    respond_to do |format|
        format.mobile { redirect_to task_categories_path, notice: 'Task category was created.' }
    end
  end

  # PUT /task_categories/1
  # PUT /task_categories/1.json
  def update
    @task_category = TaskCategory.find(params[:id])

    respond_to do |format|
      if @task_category.update_attributes(params[:task_category])
        format.mobile { redirect_to task_categories_path, notice: 'Task category was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @task_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /task_categories/1
  # DELETE /task_categories/1.json
  def destroy
    @task_category = TaskCategory.find(params[:id])
    @task_category.destroy

    respond_to do |format|
      format.mobile { redirect_to task_categories_path }
      format.json { head :no_content }
    end
  end

  def setDefaults(task_category)

    task_category.project_id = self.current_project.id
  end
end
