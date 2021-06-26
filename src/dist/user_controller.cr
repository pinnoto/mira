require "../main.cr"

class UserController < Grip::Controllers::Http

    def get_user_info(context : Context) : Context
      context
        .put_status(200)
        .send_resp("hi")
        .halt()
    end

end