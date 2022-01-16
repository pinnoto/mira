require "granite/adapter/pg"

Granite::Connections << Granite::Adapter::Pg.new(name: "postgres", url: "postgres://#{DB_USER}:#{DB_PASSWORD}@#{DB_HOST}/#{DB_NAME}")

class User < Granite::Base
  connection postgres

  column id : Int64, primary: true
  column username : String
  column password : String
  column rank : Int32
  column created_at : Time
  column last_login : Time
end

# class Session < Granite::Base
#  connection postgres
#
#  column id : String
#  column page : Int32?
#  column notes : Array(String)?
#  column bookmarks : Array(String)?
# end

class Book < Granite::Base
  connection postgres

  column id : String?, primary: true, auto: false
  column title : String?
  column authors : Array(String)?
  column date : String?
  column date_added : Time?
  column cover : String?
  column cover_directory : String?
  column directory : String?
  column success : Bool?
end

#User.migrator.drop_and_create
#Session.migrator.drop_and_create
#Book.migrator.drop_and_create
