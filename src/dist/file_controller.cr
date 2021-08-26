class FileController < Grip::Controllers::Http
    def serve_file(context : Context) : Context
        params =
            context
                .fetch_path_params
        # todo:
        # fetch the :id param
        # look up in the database the location
        # open and serve

        # time to make the fucking db

        id = params["id"]?

        if id
            begin
                #if db_book
                    begin
                        #library_json = JSON.parse(File.read(LIBRARY_JSON_DIR)).items
                        book_dir = nil
                        #puts library_json[2]
                        #library_json[2].each do |b|
                        #    
                        #end
                        context
                            .put_status(200)
                            #.binary(File.read(db_book.directory), content_type = "application/epub+zip")
                            .halt
                    rescue
                        context
                            .put_status(400)
                            .json({"error" => "File read error."})
                            .halt
                    end
                #else
                    #context
                    #    .put_status(400)
                    #    .json({"error" => "Can't find book!"})
                    #    .halt
                #end
            rescue
                context
                    .put_status(400)
                    .json({"error" => "Database error."})
                    .halt
            end
        else
            context
                .put_status(400)
                .json({"error" => "No ID provided."})
                .halt
        end
    end
end