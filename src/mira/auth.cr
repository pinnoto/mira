class TokenAuthorization
  include HTTP::Handler

  def call(context : HTTP::Server::Context) : HTTP::Server::Context
    begin
      token = context
        .get_req_header("Authorization")
        .split("Bearer ")
        .last

      payload, header = JWT.decode(token, ENV["MIRA_SECRET"], JWT::Algorithm::HS512)
      
      context
    rescue
      context
        .put_status(403)
        .halt
    end
  end
end

class AuthController < Grip::Controllers::Http
  
  def register(context : Context) : Context
    params = context.fetch_json_params

    username = params["username"].to_s
    password = params["password"].to_s
  
    if username && password
      begin
        db_username = User.query.find!({username: username})
      
        if db_username
          context
            .put_status(400)
            .json({message: "Username has been taken."})
            .halt
        else
          hasher = Argon2::Password.new
  
          user = User.new({username: username.to_s,  created_at: Time.utc})
          user.password = hasher.create(password.to_s)
          user.save!
  
          token = JWT.encode({"id" => "#{user.id}", "exp" => (Time.utc + 4.week).to_unix, "iat"  => Time.utc.to_unix}, ENV["MIRA_SECRET"], JWT::Algorithm::HS512)
          
          context
            .put_status(200)
            .json({token: token})
            .halt
        end
      rescue
        context
          .put_status(400)
          .json({message: "Username is taken."})
          .halt
      end
    else
      context
        .put_status(400)
        .json({message: "Required parameter(s) missing."})
        .halt
    end
  end

  def login(context : Context) : Context
    params = context.fetch_json_params

    username = params["username"].to_s
    password = params["password"].to_s

    if username && password
      db_user = User.query.find!({username: username})
      if db_user
        begin
          hashed_password = db_user.password
          Argon2::Password.verify_password(password, hashed_password)

          token = JWT.encode({"id" => "#{db_user.id}", "exp" => (Time.utc + 4.week).to_unix, "iat"  => Time.utc.to_unix}, ENV["MIRA_SECRET"], JWT::Algorithm::HS512)
          
          context
            .put_status(200)
            .json({token: token})
            .halt
        rescue
          context
            .put_status(400)
            .json({message: "Wrong username or password."})
            .halt
        end
      else
        context
          .put_status(400)
          .json({message: "Wrong username or password."})
      end
    else
      context
        .put_status(400)
        .json({message: "Required parameter(s) missing."})
        .halt
    end
  end

end