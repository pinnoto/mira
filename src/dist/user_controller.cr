class UserController < Grip::Controllers::Http

    def get_user_info(context : Context) : Context
      begin
        
        token = context
          .get_req_header("Authorization")
          .split("Bearer ")
          .last

        payload = JWT.decode(token, ENV["MIRA_SECRET_KEY"], JWT::Algorithm::HS512)

        db_user = User.find_by(id: payload["id"].to_i)

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

    def change_user_rank(context : Context) : Context
        begin
            token = context
                .get_req_header("Authorization")
                .split("Bearer ")
                .last

            payload = JWT.decode(token, ENV["MIRA_SECRET_KEY"], JWT::Algorithm::HS512)

            context
        rescue
            context
                .put_status(403)
                .json({"error" => "403 Forbidden"})
                .halt
        end
    end
end