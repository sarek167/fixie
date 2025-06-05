CREATE DATABASE rewards_db;
USE rewards_db;

CREATE TABLE rewards (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    blob_name VARCHAR(255) NOT NULL,
    container_name VARCHAR(255) NOT NULL,
    starter BOOLEAN NOT NULL,
    trigger_type ENUM('task_completion', 'streak', 'path_completion'),
    trigger_value INT,
    color_to_display VARCHAR(255)
);

CREATE TABLE user_rewards (
    id INT AUTO_INCREMENT PRIMARY KEY,
    reward_id INT NOT NULL,
    user_id INT NOT NULL,
    date_awarded TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (reward_id) REFERENCES rewards(id)
);
