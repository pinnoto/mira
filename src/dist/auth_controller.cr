class AuthController < Grip::Controllers::Http

    def register(context : Context) : Context

        params = context.fetch_json_params

        username = params["username"]?
        password = params["password"]?

        if username && password

            db_username = User.find_by(username: username)

            if db_username
                context
                    .put_status(400)
                    .json({"error" => "Username has been taken."})
                    .halt
            else 
                hasher = Argon2::Password.new

                user = User.new
                user.username = username.to_s
                user.password = hasher.create(password.to_s)
                user.created_at = Time.utc
                user.save

                token = JWT.encode({"id" => "#{user.id}", "exp" => (Time.utc + 1.week).to_unix, "iat"  => Time.utc.to_unix}, ENV["MIRA_SECRET_KEY"], JWT::Algorithm::HS512)

                context
                    .put_status(200)
                    .json({"token": token})
                    .halt
            end
        else
            context
                .put_status(400)
                .json({"error": "Required parameter missing"})
                .halt
        end
    end

    def login(context : Context) : Context

        params = context.fetch_json_params

        username = params["username"]?
        password = params["password"]?

        if username && password
            db_user = User.find_by(username: username.to_s)

            if db_user
                begin
                    hashed_password = db_user.password
                    Argon2::Password.verify_password(password.to_s, hashed_password)

                    token = JWT.encode({"id" => "#{db_user.id}", "exp" => (Time.utc + 1.week).to_unix, "iat"  => Time.utc.to_unix}, ENV["MIRA_SECRET_KEY"], JWT::Algorithm::HS512)

                    context
                        .put_status(200)
                        .json({"token": token})
                        .halt
                rescue
                    context
                        .put_status(400)
                        .json({"error": "Wrong username or password"})
                        .halt
                end
            else
                context
                    .put_status(400)
                    .json({"error": "Wrong username or password"})
                    .halt
            end
        else
            context
                .put_status(400)
                .json({"error": "Required parameter missing"})
                .halt
        end
    end
end