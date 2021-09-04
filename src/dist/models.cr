require "../main.cr"
require "../db.cr"

Mira::DB.sqlite("sqlite", "sqlite3://./mira.db")

class User < Granite::Base
    connection sqlite

    column id : Int64, primary: true
    column username : String
    column password : String
    #column rank : Int32
    column created_at : Time
end

class Book
    include JSON::Serializable

    property id : String
    property title : String
    property authors : Array(String)
    property date : String
    property cover : String
    property directory : String
    #property category : String
end

class Library
    include JSON::Serializable

    property totalResults : Int32
    property items : Array(Book)
end

User.migrator.drop_and_create