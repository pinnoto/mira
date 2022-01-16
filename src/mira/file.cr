class FileController < Grip::Controllers::Http
  def serve_file(context : Context) : Context
    params = context.fetch_path_params

    id = params["id"].to_s.chomp(".epub")
    puts id
    book = Book.find_by(id: id)

    if book
      begin
        dir = book.directory.to_s
        File.open(dir, "r") do |file|
          IO.copy(file, context.response)
        end

        context
          .put_status(200)
          #.put_resp_header("Content-Type", "application/epub+zip")
          .halt
      rescue
        context
          .put_status(400)
          .json({message: "Unable to open book. Check the permissions of the file and make sure it isn't removed."})
          .halt
      end
    else
      context
        .put_status(400)
        .json({message: "Book not found."})
        .halt
    end
  end
  
  def serve_cover(context : Context) : Context
    
  end
end
