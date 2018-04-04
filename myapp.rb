# myapp.rb
require 'sinatra/base'
require 'mysql2'
require 'mysql2-cs-bind'
require 'fileutils'
require 'rack-flash'
require 'openssl'

class MyApp < Sinatra::Base
  enable :sessions
  use Rack::Flash
  
  helpers do
    def db_connect()
      client = Mysql2::Client.new(
        :host     => 'localhost',
        :username => 'root',
        :password => '',
        :database => 'latestgram',
        :encoding => 'utf8mb4',
        :datatbase_timezone => :local
      )
      return client
    end
    def h(text)
      Rack::Utils.escape_html(text)
    end
  end

  before do
    $client = db_connect()
  end

  get '/' do
    sql = "
          SELECT contents.id AS content_id, image_path, caption, users.name AS name, contents.created_at AS content_created_at 
          FROM contents
          INNER JOIN users
          ON contents.user_id = users.id
          ORDER BY contents.id DESC
          LIMIT 50
          "
    contents_users = $client.xquery(sql)
    content_ids = []
    contents_users.each {|c_u|
      content_ids.push(c_u["content_id"])
    }
    sql = "
          SELECT text, content_id, users.name AS name, comments.created_at AS comment_created_at
          FROM comments
          INNER JOIN users
          ON comments.user_id = users.id
          WHERE content_id IN (?)
          "
    comments_users = $client.xquery(sql, content_ids)
    @contents = []
    # contents-users relation
    contents_users.each do |cont_u|
      contents_comments_users = []
      # comments-users relation
      comments_users.each do |comm_u|
        if cont_u["content_id"] == comm_u["content_id"]
          contents_comments_users.push({   
            user: {
              name: comm_u["name"] 
            },
            text: comm_u["text"],
            comment_created_at: comm_u["comment_created_at"]
          })
        end
      end
      # DESC by comment_created_at
      # [{..., comment_created_at: 2018-04-03 18:44:04 +0900}, {..., comment_created_at: 2018-01-01 00:00:00 +0900}] 
      comments_users.sort_by {|hash| -hash[:comment_created_at].to_i}
      @contents.push({
        content_id: cont_u["content_id"],
        image_path: cont_u["image_path"],
        caption:    cont_u["caption"],
        content_created_at: cont_u["content_created_at"],
        user: {
          name: cont_u["name"]
        },
        comments: contents_comments_users
      })
    end
    # DESC by content_created_at
    @contents.sort_by {|hash| -hash[:content_created_at].to_i}
    erb :index
  end

  post '/upload' do
    # Get params
    user_id    = 1000
    image_ext  = params[:file][:type].split("/")[1]
    image_dir    = "./public/upload/#{user_id}/image"
    file_image_path = "#{image_dir}/#{Time.now().to_i}.#{image_ext}"
    db_image_path   = file_image_path.split("/")[2..-1].join("/") # "./public/" isn't needed to display
    caption    = (params[:caption]) ? params[:caption] : ""
    created_at = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    # Save image (file)
    FileUtils.mkdir_p(image_dir) unless Dir.exist?(image_dir)
    File.open(file_image_path, "wb") do |f|
      f.write(params[:file][:tempfile].read)
    end
    # Save Contents (DB)
    sql        = "INSERT INTO contents (user_id, image_path, caption, created_at) VALUES (?, ?, ?, ?)"
    $client.xquery(sql, user_id, db_image_path, caption, created_at)
    # Generate message for flash
    flash[:status]   = "success"
    flash[:message]  = "Success your upload"
    redirect '/'
  end

  post '/comment' do
    content_id = params[:content_id]
    user_id    = 1000
    text       = params[:text]
    created_at = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    sql = "INSERT INTO comments (content_id, user_id, text, created_at) VALUES (?, ?, ?, ?)"
    $client.xquery(sql, content_id, user_id, text, created_at)
    redirect '/'
  end

  get '/signin' do
    erb :signin, :layout => :layout_sign
  end

  # post '/signin' do

  # end

  get '/signup' do
    erb :signup, :layout => :layout_sign
  end

  post '/signup' do
    username     = params[:username]
    row_password = params[:password]
    created_at   = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    digest       = OpenSSL::Digest.new('sha256')
    digest.update(row_password + created_at)
    encrypted_password = digest.hexdigest()
    sql = "INSERT INTO users (name, password, created_at) VALUES (?, ?, ?)"
    $client.xquery(sql, username, encrypted_password, created_at)
    redirect "/"
  end

  run! if app_file == $0
end
