require "../main.cr"

class Library
    include JSON::Serializable
    property totalResults : Int32
    property items : Array(Book)
end
  
class Book
    include JSON::Serializable
    property id : Int32
    property title : String
    property cover_image : String
    property dir : String
end