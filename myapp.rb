# myapp.rb
require 'sinatra/base'
require 'mysql2'

class MyApp < Sinatra::Base
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
  end

  before do
    $client = db_connect()
  end

  get '/' do
    sql = "select contents.id as content_id, image_path, caption, users.name as name from contents inner join users on contents.user_id = users.id limit 50"
    contents_users = $client.query(sql)
    sql = "select text, content_id, users.name as name from comments inner join users on comments.user_id = users.id"
    comments_users = $client.query(sql)
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
            text: comm_u["text"]
          })
        end
      end
      @contents.push({
        image_path: cont_u["image_path"],
        caption:    cont_u["caption"],
        user: {
          name: cont_u["name"]
        },
        comments: contents_comments_users
      })
    end
    erb :index
  end
  
  run! if app_file == $0
end
