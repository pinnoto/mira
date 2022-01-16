require "pg"
require "grip"
require "granite"
require "crystal-argon2"
require "jwt"
require "xml"
require "json"
require "yaml"
require "uuid"
require "digest"
require "colorize"
require "compress/zip"
require "./mira/*"

class YamlConfig
  include YAML::Serializable
  property port : Int16 = 11880
  property working_dir : String = ""
  property library : String = ""
  property covers : String = ""
  property open_registrations : Bool = false
  property db_name : String = ""
  property db_user : String = ""
  property db_password : String = ""
end

VERSION = "1.0.0"
ENV["MIRA_SECRET"] ||= Random::Secure.urlsafe_base64(256)
ENV["MIRA_CONFIG"] ||= "/etc/mira/config.yml"
# .rstrip strips the last /'s, if any, so it'd end in nothing.
PORT        = YamlConfig.from_yaml(File.read(ENV["MIRA_CONFIG"])).port.to_i
WORKING_DIR = YamlConfig.from_yaml(File.read(ENV["MIRA_CONFIG"])).working_dir.rstrip('/')
LIBRARY     = YamlConfig.from_yaml(File.read(ENV["MIRA_CONFIG"])).library.rstrip('/')
COVERS      = YamlConfig.from_yaml(File.read(ENV["MIRA_CONFIG"])).covers.rstrip('/')
DB_NAME     = YamlConfig.from_yaml(File.read(ENV["MIRA_CONFIG"])).db_name.rstrip('/')
DB_USER     = YamlConfig.from_yaml(File.read(ENV["MIRA_CONFIG"])).db_user.rstrip('/')
DB_PASSWORD = YamlConfig.from_yaml(File.read(ENV["MIRA_CONFIG"])).db_password.rstrip('/')

class Application < Grip::Application
  def routes
    pipeline :jwt_auth, [
      TokenAuthorization.new,
    ]

    scope "/api" do
      scope "/v#{VERSION[0]}" do
        scope "/auth" do
          post "/register", AuthController, as: register
          post "/login", AuthController, as: login
        end

        pipe_through :jwt_auth

        scope "/library" do
          get "/fetch", LibraryController, as: fetch_library
          get "/scan", LibraryController, as: scan_library
        end

        scope "/user" do
          get "/", UserController, as: get_user_info
          
        end
        
        #post "/post_session", SessionController, as: post_session
        #get "/get_session", SessionController, as: get_session
        get "/file/:id", FileController, as: serve_file
        # get "/cover/:id", FileController, as: serve_cover
      end
    end
  end

  def port
    PORT
  end
end

# Make sure nothing is missing.
case ""
when LIBRARY
  puts "#{"ERROR ".colorize(:red)}Library directory not set in #{ENV["MIRA_CONFIG"].to_s.colorize(:yellow)}."
when WORKING_DIR
  puts "#{"ERROR ".colorize(:red)}Library JSON file directory not set in #{ENV["MIRA_CONFIG"].to_s.colorize(:yellow)}."
when COVERS
  puts "#{"ERROR ".colorize(:red)}Cover image directory not set in #{ENV["MIRA_CONFIG"].to_s.colorize(:yellow)}."
when DB_NAME
  puts "#{"ERROR ".colorize(:red)}Database name not set in #{ENV["MIRA_CONFIG"].to_s.colorize(:yellow)}."
when DB_USER
  puts "#{"ERROR ".colorize(:red)}Database user not set in #{ENV["MIRA_CONFIG"].to_s.colorize(:yellow)}."
else
  puts "#{"INFO  ".colorize(:dark_gray)}Using config from #{ENV["MIRA_CONFIG"].to_s.colorize(:yellow)}."
  app = Application.new
  app.run
end
