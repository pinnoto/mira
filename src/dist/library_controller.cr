class LibraryController < Grip::Controllers::Http

  def fetch_library(context : Context) : Context
    # To be replaced with just putting it in a database
    library_response = File.read(LIBRARY_JSON_DIR)
    context
      .put_status(200)
      .json(JSON.parse(library_response))
      .halt
  end

  def scan_library(context : Context) : Context
    if Dir.exists?(LIBRARY_DIR) == true
      # List contents of LIBRARY_DIR
      library_files = Dir.children("#{LIBRARY_DIR}")
      
      # Start building JSON to serve
      library_json = JSON.build do |json|
        json.object do
          json.field "totalResults", library_files.size
          json.field "items" do
            json.array do
              library_files.each do |item|
                doc_hash = nil
                doc_title = nil
                doc_author = nil
                doc_date = nil
                doc_cover = nil
                doc_dir = nil

                if "#{item}".includes? ".epub"
                  begin
                    # An EPUB file is simply a ZIP archive with extra steps
                    Compress::Zip::File.open("#{LIBRARY_DIR}/#{item}") do |zip|
                      # Find the container.xml, which has metadata about where to find everything
                      entry = zip["META-INF/container.xml"] || zip["container.xml"]
                      container_xml_location = nil
                      entry.open do |io|
                        doc = XML.parse(io)
                        container_xml_location = doc.xpath_string("string(//root:container/root:rootfiles/root:rootfile[@media-type='application/oebps-package+xml']/@full-path)", {"root" => "urn:oasis:names:tc:opendocument:xmlns:container"}).to_s
                      end
                      entry = zip["#{container_xml_location}"]
                      entry.open do |io|
                        doc = XML.parse(io)
                        # I have no idea how or why this code works, but it works.
                        # I hope you do not go through the same suffering as I did.
                        doc_title = doc.xpath("//root:package/root:metadata/*[name()='dc:title']/text()", {"root" => "http://www.idpf.org/2007/opf"}).to_s
                        doc_author = doc.xpath_nodes("//root:package/root:metadata/*[name()='dc:creator']/text()", {"root" => "http://www.idpf.org/2007/opf"})
                        doc_date = doc.xpath("//root:package/root:metadata/*[name()='dc:date']/text()", {"root" => "http://www.idpf.org/2007/opf"}).to_s
                        doc_cover = doc.xpath_string("string(//root:package/root:metadata/root:meta[@name='cover']/@content)", {"root" => "http://www.idpf.org/2007/opf"}).to_s
                        doc_dir = "#{LIBRARY_DIR}/#{item}"
                      end
                    end

                    # Hashes the file, which yields a kind of unique identifier regardless of metadata
                    id = Digest::SHA256.hexdigest &.file("#{LIBRARY_DIR}/#{item}")

                    json.object do
                      json.field "id", hash # id_start += 1
                      json.field "title", doc_title
                      if doc_author
                        json.field "authors" do
                          json.array do
                            doc_author.each do |author|
                              json.string author.to_s
                            end
                          end
                        end
                      end
                      json.field "date", doc_date
                      json.field "cover", doc_cover
                      json.field "directory", doc_dir
                    end
                  # Fallback response for an entry in case it can't parse properly.
                  # Happens with some EPUBs, I couldn't figure out why.
                  rescue
                    json.object do
                      json.field "failedParse", "#{item}"
                    end
                  end
                else
                  next
                end
              end
            end
          end
        end
      end

      File.write(LIBRARY_JSON_DIR, library_json)

      context
        .put_status(200)
        .halt
    else
      context
        .put_status(400)
        .json({"error" => "Library does not exist."})
        .halt
    end
  end
end
