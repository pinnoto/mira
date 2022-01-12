class LibraryController < Grip::Controllers::Http
  
  def fetch_library(context : Context) : Context
    library_response = File.read("#{WORKING_DIR}/library.json")
    context
      .put_status(200)
      .json(JSON.parse(library_response))
      .halt
  end
  
  def scan_library(context : Context) : Context
    if Dir.exists?(LIBRARY)
      library_files = Dir.glob("#{LIBRARY}/**/*.epub")

      library_json = JSON.build do |json|
        json.object do
          json.field "totalResults", library_files.size
          json.field "items" do
            json.array do
              library_files.each do |item|
                doc_id = nil
                doc_title = nil
                doc_authors = nil
                doc_date = nil
                doc_cover = nil
                doc_dir = nil
                doc_location = nil

                begin
                  Compress::Zip::File.open("#{LIBRARY}/#{item}") do |zip|
                    container = zip["META-INF/container.xml"] || zip["container.xml"]

                    container.open do |io|
                      doc = XML.parse(io)
                      doc_location = doc.xpath_string("string(//root:container/root:rootfiles/root:rootfile[@media-type='application/oebps-package+xml']/@full-path)", {"root" => "urn:oasis:names:tc:opendocument:xmlns:container"}).to_s
                    end

                    if doc_location
                      zip[doc_location].open do |io|
                        doc = XML.parse(io)
                        # :)
                        doc_title = doc.xpath("//root:package/root:metadata/*[name()='dc:title']/text()", {"root" => "http://www.idpf.org/2007/opf"}).to_s
                        doc_authors = doc.xpath_nodes("//root:package/root:metadata/*[name()='dc:creator']/text()", {"root" => "http://www.idpf.org/2007/opf"})
                        doc_date = doc.xpath("//root:package/root:metadata/*[name()='dc:date']/text()", {"root" => "http://www.idpf.org/2007/opf"}).to_s
                        doc_cover = doc.xpath_string("string(//root:package/root:metadata/root:meta[@name='cover']/@content)", {"root" => "http://www.idpf.org/2007/opf"}).to_s
                        doc_dir = "#{LIBRARY}/#{item}"
                      end
                    end
                  end

                  doc_id = Digest::SHA256.hexdigest &.file("#{LIBRARY}/#{item}")

                  #doc = Book.new({id: doc_id, title: doc_title, date: doc_date, cover: doc_cover, directory: doc_directory})
                  #doc.authors = doc_authors
                  #doc.save!

                  json.object do
                    json.field "id", doc_id
                    json.field "title", doc_title
                    if doc_authors
                      json.field "authors" do
                        json.array do
                          doc_authors.each do |author|
                            json.string author.to_s
                          end
                        end
                      end
                    end
                    json.field "date", doc_date
                    json.field "cover", doc_cover
                  end
                rescue
                  json.object do
                    json.field "failedParse", item
                  end
                end
              end
            end
          end
        end
      end
      
      File.write("#{WORKING_DIR}/library.json", library_json)
      
      context
        .put_status(200)
        .json({message: "Scan successful."})
        .halt
    else
      context
        .put_status(400)
        .json({message: "Library directory does not exist."})
        .halt
    end
  end

end