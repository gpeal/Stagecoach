class SessionsController < ApplicationController

    require "uri"
    require "open-uri"
    require "net/http"
    require "net/https"
    skip_before_filter :require_login

    def new
        respond_to do |format|
            format.html
        end
    end

    #GET  /oauth2callback
    def create_google
        if !params["error"].nil?
            redirect_to root_url
        elsif !params["code"].nil?
            #send a post request with the temporary authorization code to get the long term access token
            post_params = {"code" => params["code"],
                            "client_id" => APP_CONFIG['google_oauth_client_id'],
                            "client_secret" => APP_CONFIG['google_oauth_client_secret'],
                            "redirect_uri" => APP_CONFIG['google_oauth_redirect_uri'],
                            "grant_type" => "authorization_code"}
            uri = URI.parse("https://accounts.google.com/o/oauth2/token")
            http = Net::HTTP.new(uri.host, uri.port)
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE
            http.use_ssl = true
            request = Net::HTTP::Post.new(uri.request_uri)
            request["Content-Type"] = "application/x-www-form-urlencoded"
            request.body = post_params.to_query
            response = http.request(request)
            if response.code == "200"
                token = JSON.parse(response.body)["access_token"]
                uri = URI.parse("https://www.googleapis.com/oauth2/v2/userinfo")
                http = Net::HTTP.new(uri.host, uri.port)
                http.use_ssl = true
                http.verify_mode = OpenSSL::SSL::VERIFY_NONE
                path = "/oauth2/v2/userinfo"
                header = { "Authorization" => "OAuth #{token}" }
                response = http.get(path, header)
                debugger
            end

        end
        redirect_to root_url
    end

    #POST  /oauth2callback
    def receive_google_access_token
        #success
        if params["token_type"] == "bearer"

        end
    end

    #GET /auth/:provider/callback
    def create_facebook
        auth = request.env['omniauth.auth']
        auth_type = 'existing'
        if !(@auth = Authorization.find_from_hash(auth))
            # Create a new user or add an auth to existing user, depending on
            # whether there is already a user signed in.
            auth_type = 'new'
            @auth = Authorization.create_from_hash(auth, current_user)
        end
            # Log the authorizing user in.
            self.current_user=(@auth.user)
            if !is_mobile_device?
              flash[:success] = "Welcome, #{current_user.name}."
            end
            if session.present?
                session[:project_id] = current_user.projects.find(:all, :order => "created_at DESC", :limit => 1).first
            end

            if auth_type == 'new'
                redirect_to edit_user_url(current_user)
            else
                redirect_to root_url
            end
    end

    def guest
        @user = User.find_by_name("Guest")
        if(@user.nil?)
            @user = User.new(:name => "Guest", :email => "guest@stagecoach.com" )
            @user.save
        end

        self.current_user=(@user)

        self.current_project= self.current_user.projects.find(:all, :order => "created_at DESC", :limit => 1).first
        redirect_to root_url
    end

    def destroy
        session[:user_id] = nil
        session[:project_id] = nil
        if !is_mobile_device?
            flash[:info] = "You have successfully logged out"
        end
        redirect_to root_url
    end

end
