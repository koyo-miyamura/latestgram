# Latestgram

## 構成
* top
* login
* signup

## テーブル定義
### リレーション
* "Users" has many "Contents" 
* "Users" has many "Comments"
* "Contents" has many "Comments"

### Users
|カラム名|属性|NN|UQ|
|:--:|:--:|:--:|:--:|
|id|integer|T|T|
|name|string|T|T|
|password|string|T|F|
|created_at|datetime|T|F|

### Contents
|カラム名|属性|NN|UQ|
|:--:|:--:|:--:|:--:|
|id|integer|T|T|
|user_id|integer|T|F|
|image_path|string|T|F|
|caption|string|F|F|
|created_at|datetime|T|F|

### Comments
|カラム名|属性|NN|UQ|
|:--:|:--:|:--:|:--:|
|id|integer|T|T|
|content_id|integer|T|F|
|user_id|integer|T|F|
|text|string|T|F|
|created_at|datetime|T|F|
