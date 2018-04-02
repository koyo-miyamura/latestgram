CREATE DATABASE if not exists `latestgram` DEFAULT CHARACTER SET utf8mb4;
USE latestgram;

CREATE TABLE if not exists `users` (
    id         INTEGER      PRIMARY KEY AUTO_INCREMENT,
    name       VARCHAR(191) NOT NULL UNIQUE,
    passeord   VARCHAR(191) NOT NULL,
    created_at DATETIME     NOT NULL
);

CREATE TABLE if not exists `contents` (
    id         INTEGER      PRIMARY KEY AUTO_INCREMENT,
    user_id    INTEGER      NOT NULL,
    image_path VARCHAR(191) NOT NULL,
    caption    VARCHAR(191) NOT NULL,
    created_at DATETIME     NOT NULL
);

CREATE TABLE if not exists `comments` (
    id         INTEGER  PRIMARY KEY AUTO_INCREMENT,
    content_id INTEGER  NOT NULL,
    user_id    INTEGER  NOT NULL,
    text       TEXT,
    created_at DATETIME NOT NULL
);