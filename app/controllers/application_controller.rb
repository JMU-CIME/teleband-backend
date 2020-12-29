class ApplicationController < ActionController::API
    include Rails.application.routes.url_helpers

    def secret_key
        "mu$ic1$LiF3n@Ti0NaL$t@nDarD$"
    end

    def encode(payload)
        JWT.encode(payload, secret_key, "HS256")
    end

    def decode(token)
        JWT.decode(token, secret_key, true, {algorithm: "HS256"})[0]
    end

    def auth_request(request, is_teacher)
        begin
            token = request.headers["Authentication"]
            payload = decode(token)
            if is_teacher
                @current_user = Teacher.find(payload["teacher_id"])
            else
                @current_user = Student.find_by(school_id: payload["student_id"])
            end
        rescue ActiveRecord::RecordNotFound => e
            render json: { errors: e.message }, status: :unauthorized
        rescue JWT::DecodeError => e
            render json: { errors: e.message }, status: :unauthorized
        end
    end
end
