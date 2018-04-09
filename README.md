# Latestgram

## 概要
画像+キャプションを投稿できるWebサービス

最新50件の画像を表示する

#### Quick Start
`docker-compose up`してdockerに割り当てられているip(docker_ipとする)の8080ポートでアクセス`docker_ip:8080`

例）docker for mac なら `localhost:8080`

`docker_ip:4567`でnginx経由ではなく直接アクセス可

## 構成
* top
* user/user_id
* login
* signup

## テーブル定義
### リレーション
* "Users" has many "Contents" 
* "Users" has many "Comments"
* "Contents" has many "Comments"

### Users
|カラム名|属性|NN|UQ|
|:--:|:--:|:--:|:--:|
|id|integer|T|T|
|name|string|T|T|
|password|string|T|F|
|created_at|datetime|T|F|

### Contents
|カラム名|属性|NN|UQ|
|:--:|:--:|:--:|:--:|
|id|integer|T|T|
|user_id|integer|T|F|
|image_path|string|T|F|
|caption|string|F|F|
|created_at|datetime|T|F|

### Comments
|カラム名|属性|NN|UQ|
|:--:|:--:|:--:|:--:|
|id|integer|T|T|
|content_id|integer|T|F|
|user_id|integer|T|F|
|text|string|T|F|
|created_at|datetime|T|F|
