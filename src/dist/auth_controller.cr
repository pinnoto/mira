require "../main.cr"
require "./db_model.cr"

class AuthController < Grip::Controllers::Http

    def register(context : Context) : Context

        params = context.fetch_json_params
        db_username = User.find_by(username: params["username"].to_s)

        if db_username 
            context
                .put_status(400)
                .json({"error" => "Username has been taken."})
                .halt
        else 
            hasher = Argon2::Password.new

            user = User.new
            user.username = params["username"].to_s
            user.password = hasher.create(params["password"].to_s)
            user.save

            context
                .put_status(200)
                .halt
        end
    end

    def login(context : Context) : Context

        params = context.fetch_json_params
        db_user = User.find_by(username: params["username"].to_s)

        if db_user

            hashed_password = db_user.password
            Argon2::Password.verify_password(params["password"].to_s, hashed_password)

            token = JWT.encode({"id" => "#{db_user.id}", "exp" => (Time.utc + 1.week).to_unix, "iat"  => Time.utc.to_unix}, ENV["MIRA_SECRET_KEY"], JWT::Algorithm::HS512)

            context
                .put_status(200)
                .json({"token": token})
                .halt

        else
            context
                .put_status(400)
                .json({"error" => "User does not exist."})
                .halt
        end
    end
end