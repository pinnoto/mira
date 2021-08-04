require "granite"
require "granite/adapter/sqlite"

module Mira::DB
    def self.sqlite(name, url)
        Granite::Connections << Granite::Adapter::Sqlite.new(name: name, url: url)
    end
end

Mira::DB.sqlite("sqlite", "sqlite3://./db.sqlite3")

class User < Granite::Base
    connection sqlite

    column id : Int64, primary: true
    column username : String
    column password : String
end

class Book < Granite::Base
    connection sqlite

    column hash : String, primary: true
    column title : String
    column authors : Array(String)
    column date : String
    column cover : String
    column directory : String
end