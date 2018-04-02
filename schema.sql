CREATE DATABASE IF NOT EXISTS `latestgram` DEFAULT CHARACTER SET utf8mb4;
USE latestgram;

CREATE TABLE IF NOT EXISTS `users` (
    id         INTEGER      PRIMARY KEY AUTO_INCREMENT,
    name       VARCHAR(191) NOT NULL UNIQUE,
    passeord   VARCHAR(191) NOT NULL,
    created_at DATETIME     NOT NULL
);

CREATE TABLE IF NOT EXISTS `contents` (
    id         INTEGER      PRIMARY KEY AUTO_INCREMENT,
    user_id    INTEGER      NOT NULL,
    image_path VARCHAR(191) NOT NULL,
    caption    VARCHAR(191),
    created_at DATETIME     NOT NULL
);

CREATE TABLE IF NOT EXISTS `comments` (
    id         INTEGER  PRIMARY KEY AUTO_INCREMENT,
    content_id INTEGER  NOT NULL,
    user_id    INTEGER  NOT NULL,
    text       TEXT,
    created_at DATETIME NOT NULL
);