class LibraryController < Grip::Controllers::Http
  def fetch_library(context : Context) : Context
    # library_response = File.read("#{WORKING_DIR}/library.json")
    begin
      library_json = JSON.build do |json|
        json.object do
          docs = Book.all
          if docs
            json.field "totalResults", docs.size
            json.field "items" do
              json.array do
                docs.each do |doc|
                  if doc.success == true
                    json.object do
                      json.field "id", doc.id
                      json.field "title", doc.title
                      json.field "authors" do
                        json.array do
                          begin
                            doc.authors.try &.each do |author|
                              json.string author.to_s
                            end
                          rescue
                            puts "help me I am in agony"
                          end
                        end
                      end
                      json.field "date", doc.date
                      json.field "dateAdded", doc.date_added
                      json.field "success", doc.success
                    end
                  else
                    json.object do
                      json.field "id", doc.id
                      json.field "dateAdded", doc.date_added 
                      json.field "success", doc.success
                    end
                  end
                end
              end
            end
          end
        end
      end
      context
        .put_status(200)
        .json(JSON.parse(library_json))
        .halt
    rescue
      context
        .put_status(400)
        .json({message: "Fetching library failed."})
        .halt
    end
  end

  def scan_library(context : Context) : Context
    if Dir.exists?(LIBRARY)
      library_files = Dir.glob("#{LIBRARY}/**/*.epub")
      library_files.each do |item|
        doc_id = nil
        doc_title = nil
        doc_authors = nil
        doc_date = nil
        doc_cover = nil
        doc_dir = nil
        doc_location = nil

        begin
          Compress::Zip::File.open("#{item}") do |zip|
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
                doc_authors = doc_authors.map(&.content.to_s)
                doc_date = doc.xpath("//root:package/root:metadata/*[name()='dc:date']/text()", {"root" => "http://www.idpf.org/2007/opf"}).to_s
                doc_cover = doc.xpath_string("string(//root:package/root:manifest/root:item[@id='cover']/@href)", {"root" => "http://www.idpf.org/2007/opf"}).to_s
                doc_dir = "#{item}"
              end
            end
          end

          doc_id = Digest::SHA256.hexdigest &.file("#{item}")
          doc = Book.find_by(id: doc_id)

          unless doc && doc_authors
            doc = Book.new
            doc.id = doc_id
            doc.title = doc_title
            doc.authors = doc_authors
            doc.date = doc_date
            doc.date_added = Time.utc
            doc.cover = doc_cover
            doc.directory = doc_dir
            doc.success = true
            doc.save
          end
        rescue
          puts "#{"ERROR ".colorize(:red)}Failed to parse #{item.colorize(:yellow)}"

          doc_id = Digest::SHA256.hexdigest &.file("#{item}")
          doc = Book.find_by(id: doc_id)

          unless doc
            doc = Book.new
            doc.id = doc_id
            doc.date_added = Time.utc
            doc.directory = doc_dir
            doc.success = false
            doc.save
          end
        end
      end

      # File.write("#{WORKING_DIR}/library.json", library_json)

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
