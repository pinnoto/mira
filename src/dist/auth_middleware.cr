require "../main.cr"

class TokenAuthorization
    include HTTP::Handler

    def call(context : HTTP::Server::Context) : HTTP::Server::Context
        begin
            token = context
                .get_req_header("Authorization")
                .split("Bearer ")
                .last

            payload, header = JWT.decode(token, SECRET_KEY, JWT::Algorithm::HS512)

            context
        rescue
            context
                .put_status(400)
                .json({"error" => "Authentication error"})
                .halt
        end
    end
end
