class SessionController < Grip::Controllers::Http
  def post_session(context : Context) : Context
    params = context.fetch_json_params

    id = params["id"].to_s
    page = params["page"]?.to_s
    notes = params["notes"]?.to_s
    bookmarks = params["bookmarks"]?.to_s

    context
      .put_status(200)
      .halt
  end

  def get_session(context : Context) : Context
    params = context.fetch_path_params

    id = params["id"].to_s

    context
      .put_status(200)
      #    .json({page: page, notes: [notes], bookmars: [bookmarks]})
      .halt
  end
end
