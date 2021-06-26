require "granite"
require "granite/adapter/sqlite"

module Mira::DB
    def self.sqlite(name, url)
        Granite::Connections << Granite::Adapter::Sqlite.new(name: name, url: url)
    end
end