class ApplicationController < ActionController::Base
  protect_from_forgery
  
  has_mobile_fu
  before_filter :set_request_format
  def set_request_format
    request.format = :mobile if is_mobile_device?
  end
  
  before_filter :set_abingo_identity
  def set_abingo_identity
    if (session[:abingo_identity])
      Abingo.identity = session[:abingo_identity]
    else
      session[:abingo_identity] = Abingo.identity = rand(10 ** 10).to_i
    end
  end


  before_filter :require_login
  def require_login
    unless current_user?
      if is_mobile_device?
        redirect_to '/signin'
      end
    end
  end 
  
  #Authorization stuff
  protected
    def current_user
      @current_user ||= User.find_by_id(session[:user_id])
    end
    def current_project
      @current_project  ||= session[:project_id]
    end
    def current_project=(project_id)
      session[:project_id] = Project.find_by_id(project_id)
      @current_project = session[:project_id]
    end
    def current_user?
      !!current_user
    end
    def current_user=(user)
      @current_user = user
      session[:user_id] = user.id
    end
    def project_select_options
      @project_select_options =  []
      if current_project != nil
        @project_select_options << [current_project.name, current_project.id]
        current_user.projects.each do |project| 
          if project.id != current_project.id 
          @project_select_options << [project.name, project.id]
          end
        end
      else
      @project_select_options = ["No Projects Yet!"]
      end
      @project_select_options
    end
    helper_method :current_user, :current_user?, :current_user=, :current_project, :current_project=, :project_select_options
  #End authorization stuff
  
end
