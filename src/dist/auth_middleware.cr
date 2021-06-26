require "../main.cr"

class TokenAuthorization
    include HTTP::Handler

    def call(context : HTTP::Server::Context) : HTTP::Server::Context
        begin
            token = context
                .get_req_header("Authorization")
                .split("Bearer ")
                .last

            context
        rescue
            raise Grip::Exceptions::BadRequest.new
        end
    end
end