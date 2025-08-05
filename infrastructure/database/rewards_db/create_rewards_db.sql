CREATE DATABASE rewards_db;
USE rewards_db;

CREATE TABLE rewards (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    blob_name VARCHAR(255) NOT NULL,
    container_name VARCHAR(255) NOT NULL,
    starter BOOLEAN NOT NULL,
    trigger_type ENUM('task_completion', 'streak', 'path_completion'),
    trigger_value INT,
    color_id INTEGER REFERENCES colors(id)
);

CREATE TABLE user_rewards (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    reward_id INT UNSIGNED NOT NULL,
    user_id INT UNSIGNED NOT NULL,
    date_awarded TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (reward_id) REFERENCES rewards(id)
);

CREATE TABLE avatar_state (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    skin_color VARCHAR(20) NOT NULL,
    eyes_color VARCHAR(20) NOT NULL,
    hair VARCHAR(50) NOT NULL,
    hair_color VARCHAR(20) NOT NULL,
    top_clothes VARCHAR(50) NOT NULL,
    top_clothes_color VARCHAR(20) NOT NULL,
    bottom_clothes VARCHAR(50) NOT NULL,
    bottom_clothes_color VARCHAR(20) NOT NULL,
    lipstick VARCHAR(10) DEFAULT '0',
    blush VARCHAR(10) DEFAULT '0',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE colors (
  id SERIAL PRIMARY KEY,
  name VARCHAR(20) UNIQUE NOT NULL,
  hex VARCHAR(10) NOT NULL
);