require "../main.cr"
require "../db.cr"

Mira::DB.sqlite("sqlite", "sqlite3://./mira.db")

class User < Granite::Base
    connection sqlite

    column id : Int64, primary: true
    column username : String
    column password : String
    column rank : Int32
    column created_at : Time
end

class Session < Granite::Base 
    connection sqlite
    
    column id : Int64, primary: true
    column user_id : Int64
    column book_id : String 
    column page : Int32
    column bookmarks : Array(String)
end

#User.migrator.drop_and_create