class FileController < Grip::Controllers::Http
    def serve_file(context : Context) : Context
        context
            .put_status(200)
            .halt
    end
end