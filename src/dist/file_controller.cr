class FileController < Grip::Controllers::Http

    def serve_file(context : Context) : Context
        params =
            context
                .fetch_path_params

        id = params["id"]?

        items = Array(Book).from_json(File.read(LIBRARY_JSON_DIR), root: "items")

        if id
            begin
                begin
                    #library_json = JSON.parse(File.read(LIBRARY_JSON_DIR)).items
                    book = items.find do |item|
                        item.id == params["id"] 
                    end

                    if book && book.directory && File.exists?(book.directory)
                        File.open(book.directory, "r") do |file|
                           IO.copy(file, context.response)
                        end

                        context
                            .put_resp_header("Content-Type", "application/epub+zip")
                            .put_status(200)
                            .halt
                    else
                        context
                            .put_status(400)
                            .json({"error" => "Can't find book"})
                            .halt
                    end
                rescue
                    context
                        .put_status(400)
                        .json({"error" => "File read error."})
                        .halt
                end
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

    # This route is a security concern. Verify that cover image is a real image.
    def serve_file_cover(context : Context) : Context
        params =
            context
                .fetch_path_params

        id = params["id"]?

        items = Array(Book).from_json(File.read(LIBRARY_JSON_DIR), root: "items")

        if id
            begin
                begin
                    #library_json = JSON.parse(File.read(LIBRARY_JSON_DIR)).items
                    book = items.find do |item|
                        item.id == params["id"] 
                    end

                    if book && book.directory && book.cover
                        Compress::Zip::File.open(book.directory) do |zip|
                            entry = zi
                            entry.open do |io|
                                doc = XML.parse(io)
                                cover_image = doc.xpath_string("string(//root:package/root:manifest/root:[@id='#{book.cover}']/@href)", {"root" => "http://www.idpf.org/2007/opf"}).to_s
                                puts cover_image
                            end
                            #if entry
                            #    entry.open do |io|
                            #        puts "5 #{book.cover}"
                            #        IO.copy(io, context.response)
                            #    end
                            #end
                        end

                        context
                            .put_status(200)
                            .halt
                    else
                        context
                            .put_status(400)
                            .json({"error" => "Can't find book or cover"})
                            .halt
                    end
                rescue
                    context
                        .put_status(400)
                        .json({"error" => "File read error."})
                        .halt
                end
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