require "../main.cr"

class TokenAuthorization
    include HTTP::Handler

    def call(context : HTTP::Server::Context) : HTTP::Server::Context
        begin
            token = context
                .get_req_header("Authorization")
                .split("Bearer ")
                .last

            payload, header = JWT.decode(token, "hhh", JWT::Algorithm::HS256)

            puts payload["id"]            

            context
                .put_status(200)
                .halt
        rescue
            raise Grip::Exceptions::BadRequest.new
        end
    end
end
