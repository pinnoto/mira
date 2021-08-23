require "../main.cr"
require "../db.cr"

Mira::DB.sqlite("sqlite", "sqlite3://./db.sqlite3")

class User < Granite::Base
    connection sqlite

    column id : Int64, primary: true
    column username : String
    column password : String
    column created_at : Time
end

User.migrator.drop_and_create
