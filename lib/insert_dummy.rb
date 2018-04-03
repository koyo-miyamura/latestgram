require "mysql2"

client = Mysql2::Client.new(
    :host     => 'localhost',
    :username => 'root',
    :password => '',
    :database => 'latestgram',
    :encoding => 'utf8mb4',
    :datatbase_timezone => :local
)

sql = "INSERT INTO users (name, password, created_at) VALUES (?, ?, ?)"
statement = client.prepare(sql)
for i in 1..1000 do
    name       = "hoge" + i.to_s
    pass       = "hoge" + i.to_s
    created_at = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    statement.execute(name, pass, created_at)
end

sql = "INSERT INTO contents (user_id, image_path, caption, created_at) VALUES (?, ?, ?, ?)"
statement = client.prepare(sql)
for i in 1..1000 do
    user_id    = i
    caption    = "hogehoge by " + i.to_s
    image_path = "hoge" + i.to_s
    created_at = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    statement.execute(user_id, caption, image_path, created_at)
end

sql = "INSERT INTO comments (content_id, user_id, text, created_at) VALUES (?, ?, ?, ?)"
statement = client.prepare(sql)
for i in 1..1000 do
    content_id = i
    user_id    = i
    text       = "fugafuga by" + i.to_s
    created_at = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    statement.execute(content_id, user_id, text, created_at)
end