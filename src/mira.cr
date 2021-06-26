require "compress/zip"
require "grip"
require "json"
require "xml"

LIBRARY_DIR = "/root/library"
CONFIG_DIR = "/root/mira/config.yml"
LIBRARY_JSON_DIR = "/root/mira/library.json"
API_URL = "/api/v1"

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

class LibraryController < Grip::Controllers::Http

  def fetch_library(context : Context) : Context

    library_response = File.read(LIBRARY_JSON_DIR)

    context
      .put_status(200)
      .send_resp(content: library_response, )
      .halt()
  end

  def scan_library(context : Context) : Context
    library_files = Dir.children("#{LIBRARY_DIR}")
    id_start = 0

    library_json = JSON.build do |json|
      json.object do
        json.field "totalResults", library_files.size
        json.field "items" do
          json.array do
            library_files.each do |item|
  
              doc_title = nil
              doc_date = nil
              doc_author = nil
              doc_cover = nil
              doc_dir = nil
  
              Compress::Zip::File.open("#{LIBRARY_DIR}/#{item}") do |zip|
                entry = zip["META-INF/container.xml" || "container.xml"]
                container_xml_location = nil
                entry.open do |io|
                  doc = XML.parse(io)
                  container_xml_location = doc.xpath_string("string(//root:container/root:rootfiles/root:rootfile[@media-type='application/oebps-package+xml']/@full-path)", {"root" => "urn:oasis:names:tc:opendocument:xmlns:container"}).to_s
                end
                entry = zip["#{container_xml_location}"]
                entry.open do |io|
                  doc = XML.parse(io)
                  doc_title = doc.xpath("//root:package/root:metadata/*[name()='dc:title']/text()", {"root" => "http://www.idpf.org/2007/opf"}).to_s
                  doc_date = doc.xpath("//root:package/root:metadata/*[name()='dc:date']/text()", {"root" => "http://www.idpf.org/2007/opf"}).to_s
                  doc_author = doc.xpath("//root:package/root:metadata/*[name()='dc:creator']/text()", {"root" => "http://www.idpf.org/2007/opf"}).to_s
                  doc_cover = doc.xpath_string("string(//root:package/root:metadata/root:meta[@name='cover']/@content)", {"root" => "http://www.idpf.org/2007/opf"}).to_s
                  doc_dir = "#{LIBRARY_DIR}/#{item}"
                end
              end
  
              json.object do 
                json.field "id", id_start += 1
                json.field "title", doc_title
                json.field "author", doc_author
                json.field "date", doc_date
                json.field "cover", doc_cover
                json.field "directory", doc_dir
              end
            end
          end
        end
      end
    end
  
    File.write("/root/mira/library.json", library_json)
    
    context
      .put_status(200)
      .halt()
  end
end

class Application < Grip::Application
  def routes
    get "#{API_URL}/fetch_library", LibraryController, as: fetch_library
    get "#{API_URL}/scan_library", LibraryController, as: scan_library
  end
  def port
    11885
  end
end

app = Application.new
app.run
