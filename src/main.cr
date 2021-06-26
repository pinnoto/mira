require "sqlite3"
require "db"
require "grip"
require "crystal-argon2"
require "compress/zip"
require "jwt"
require "json"
require "xml"
require "yaml"
require "./dist/*"
require "./db.cr"

LIBRARY_DIR = "/root/library"
CONFIG_DIR = "/root/mira/config.yml"
LIBRARY_JSON_DIR = "/root/mira/library.json"
API_URL = "/api/v1"

class YamlConfig
  include YAML::Serializable
  property port : UInt16
  property secret_key : String
end

yaml_config = YamlConfig.from_yaml(File.read(CONFIG_DIR))

class Application < Grip::Application

  def routes
    
    pipeline :jwt_auth, [
      TokenAuthorization.new
    ]

    scope "/api" do
      scope "/v1" do
        scope "/auth" do
          pipe_through :jwt_auth

          get "/fetch_library", LibraryController, as: fetch_library
          get "/scan_library", LibraryController, as: scan_library
          get "/user_info", UserController, as: get_user_info
        end
        post "/register", AuthController, as: register
        post "/login", AuthController, as: login
      end
    end
  end

  def port
    YamlConfig.from_yaml(File.read(CONFIG_DIR)).port.to_i
  end

end

app = Application.new
app.run