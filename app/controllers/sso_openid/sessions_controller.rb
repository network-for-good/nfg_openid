module SsoOpenid
  class SessionsController < ::ApplicationController

    def create
      omniauth_data = env['omniauth.auth']
      admin = Admin.from_omniauth(omniauth_data, request.subdomain)
      if admin
        admin.uid = omniauth_data.uid
        admin.oauth_token = omniauth_data.credentials.token
        admin.oauth_expires_at = DateTime.now + omniauth_data.credentials.expires_in.seconds
        admin.save
        sign_in(admin)

        redirect_to sso_openid_redirect_after_sign_in_path
      else
        failure
      end
    end

    def destroy
      sign_out
      redirect_to root_path
    end

    def failure
      redirect_to sso_openid_failure_path
    end

    def setup
      request.env['omniauth.strategy'].options[:client_options][:redirect_uri] = callback_url('sso-openid', subdomain: request.subdomain)
      render :text => "Omniauth setup phase.", :status => 200
    end

    private

    def current_donor
      nil
    end
  end
end