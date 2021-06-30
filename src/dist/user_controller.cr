require "../main.cr"
require "./db_model.cr"

class UserController < Grip::Controllers::Http

    def get_user_info(context : Context) : Context
      begin
        
        token = context
          .get_req_header("Authorization")
          .split("Bearer ")
          .last

        payload, header = JWT.decode(token, SECRET_KEY, JWT::Algorithm::HS512)

        db_user = User.find_by(id: payload["id"].to_s.to_i)

        if db_user
          context
            .put_status(200)
            .json({"username" => "#{db_user.username}"})
            .halt()
        else
          context
            .put_status(400)
            .json({"error" => "400"})
            .halt()
        end

      rescue

        context
          .put_status(400)
          .json({"error" => "Authentication error"})
          .halt

      end
    end

end