Clear::SQL.init("postgres://#{DB_USER}:#{DB_PASSWORD}@localhost/#{DB_NAME}")

class User
  include Clear::Model

  column id : UUID, primary: true

  column username : String
  column password : String
  column rank : Int8
  column created_at : Time
end

class Session
  include Clear::Model

  column id : String, primary: true
  column page : Int32?
  column notes : Array(String)?
  column bookmarks : Array(String)?
end

class Book
  include Clear::Model
  
  column id : String, primary: true
  column title : String
  column authors : Array(String)
  column date : String?
  column date_added : Time
  column cover : String?
  column directory : String
end