class WebServer < Sinatra::Base
  set :root, ROOT_DIR

  get "/" do
    erb :index
  end

end
