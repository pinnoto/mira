class FileController < Grip::Controllers::Http
    def serve_file(context : Context) : Context
        params =
            context
                .fetch_path_params

        context
            .put_status(200)
            .json(params)
            .halt
    end
end