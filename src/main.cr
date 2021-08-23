require "sqlite3"
require "db"
require "grip"
require "colorize"
require "crystal-argon2"
require "compress/zip"
require "jwt"
require "json"
require "xml"
require "yaml"
require "uuid"
require "digest"
require "./dist/*"

class YamlConfig
  include YAML::Serializable
  property port : UInt32 = 11885
  property library_dir : String = ""
  property library_json : String = ""
  property covers_dir : String = ""
end

ENV["MIRA_SECRET_KEY"] ||= "hhh" #Random::Secure.urlsafe_base64(64)
ENV["MIRA_CONFIG_DIR"] ||= "/etc/mira/config.yml"
LIBRARY_DIR = YamlConfig.from_yaml(File.read(ENV["MIRA_CONFIG_DIR"])).library_dir.rstrip('/')
LIBRARY_JSON_DIR = YamlConfig.from_yaml(File.read(ENV["MIRA_CONFIG_DIR"])).library_json.rstrip('/')
COVERS_DIR = YamlConfig.from_yaml(File.read(ENV["MIRA_CONFIG_DIR"])).covers_dir.rstrip('/') # .rstrip strips the last /'s, if any, so it'd end in nothing.
puts COVERS_DIR
API_URL = "/api/v1"

class Application < Grip::Application

  #def custom : Array(HTTP::Handler)
  #  [
  #    HTTP::StaticFileHandler.new(public_dir: "./files/static/", fallthrough: true, directory_listing: false),
  #  ] of HTTP::Handler
  #end

  def routes
    
    pipeline :jwt_auth, [
      TokenAuthorization.new
    ]
    scope "/api" do
      scope "/v1" do
        pipe_through :jwt_auth

        get "/fetch_library", LibraryController, as: fetch_library
        get "/scan_library", LibraryController, as: scan_library
        get "/get_user_info", UserController, as: get_user_info
        get "/files/:id", FileController, as: serve_file
      end
    end
    
    post "/api/v1/register", AuthController, as: register
    post "/api/v1/login", AuthController, as: login
  
  end

  def port
    YamlConfig.from_yaml(File.read(ENV["MIRA_CONFIG_DIR"])).port.to_i
  end

end

case ""
when LIBRARY_DIR
  puts "#{"ERROR ".colorize(:red)}Library directory not set in #{ENV["MIRA_CONFIG_DIR"]}"
when LIBRARY_JSON_DIR
  puts "#{"ERROR ".colorize(:red)}Library JSON file directory not set in #{ENV["MIRA_CONFIG_DIR"]}"
when COVERS_DIR
  puts "#{"ERROR ".colorize(:red)}Cover image directory not set in #{ENV["MIRA_CONFIG_DIR"]}"
else
  app = Application.new
  app.run
end