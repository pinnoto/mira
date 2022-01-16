class FileController < Grip::Controllers::Http
  def serve_file(context : Context) : Context
    params = context.fetch_path_params

    id = params["id"].to_s

    items = Array(Book).from_json(File.read("#{WORKING_DIR}/library.json"), root: "items")

    if id
      context
        .put_status(200)
        
    else
      context
        .put_status(400)
        .json({message: "No ID provided."})
        .halt
    end
  end
  
  def serve_cover(context : Context) : Context
    
  end
end
