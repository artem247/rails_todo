class SigninController < ApplicationController
    def create
        user = user.find_by!(email: params[:email])
        if user.authenticat(params[:password])
            payload = { user_id: user.id}
            session = JWTSessions::Session.new(payload, refresh_by_access_allowed: true)
            tokens = session.login
            response.set_cookie(JWTSessions.access_cookiem
                                value: tokens[:access],
                                httponly: true,
                                secure: Rails.env.production?)
            
            render json: { csrf: tokens[:csrf] }

        else
            not_authorized
        end
    end
end