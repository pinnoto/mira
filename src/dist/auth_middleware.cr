class TokenAuthorization
    include HTTP::Handler

    def call(context : HTTP::Server::Context) : HTTP::Server::Context
        begin
            token = context
                .get_req_header("Authorization")
                .split("Bearer ")
                .last

            payload, header = JWT.decode(token, ENV["MIRA_SECRET_KEY"], JWT::Algorithm::HS512)

            context
        rescue
            context
                .put_status(403)
                .json({"error" => "403 Forbidden"})
                .halt
        end
    end
end