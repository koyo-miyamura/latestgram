# myapp.rb
require 'sinatra/base'
require 'mysql2'
require 'mysql2-cs-bind'

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

  run! if app_file == $0
end
