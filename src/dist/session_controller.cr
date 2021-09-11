class SessionController < Grip::Controllers::Http
    def get_session (context : Context) : Context
        
        params =
            context
                .fetch_path_params

        id = params["id"]?
        page = params["page"]?

        context
            .put_status(200)
            .halt
    end
end