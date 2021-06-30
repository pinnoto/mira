require "sqlite3"
require "db"
require "grip"
require "crystal-argon2"
require "compress/zip"
require "jwt"
require "json"
require "xml"
require "yaml"
require "uuid"
require "./dist/*"
require "./db.cr"

class YamlConfig
  include YAML::Serializable
  property port : UInt16
  property library_dir : String
end

# ENV["MIRA_SECRET_KEY"] ||= Random::Secure.urlsafe_base64(64)
SECRET_KEY = "hhh"
CONFIG_DIR = "/etc/mira/config.yml"
LIBRARY_DIR = YamlConfig.from_yaml(File.read(CONFIG_DIR)).library_dir
LIBRARY_JSON_DIR = YamlConfig.from_yaml(File.read(CONFIG_DIR)).library_json
API_URL = "/api/v1"

class Application < Grip::Application

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
      end
    end
    
    post "/api/v1/register", AuthController, as: register
    post "/api/v1/login", AuthController, as: login
  
  end

  def port
    YamlConfig.from_yaml(File.read(CONFIG_DIR)).port.to_i
  end

end

app = Application.new
app.run