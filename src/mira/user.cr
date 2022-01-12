class UserController < Grip::Controllers::Http

  def get_user_info(context : Context) : Context
    begin
      token = context
        .get_req_header("Authorization")
        .split("Bearer ")
        .last

      payload, header = JWT.decode(token, ENV["MIRA_SECRET"], JWT::Algorithm::HS512)

      db_user = User.query.find!({id: payload["id"]})

      if db_user
        context
          .put_status(200)
          .json({username: "#{db_user.username}"})
          .halt
      else
        context
          .put_status(400)
          .halt
      end
    rescue
      context
        .put_status(403)
        .halt
    end
  end

end