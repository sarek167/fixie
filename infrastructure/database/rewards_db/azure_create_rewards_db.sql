USE rewards_db;
GO

CREATE TABLE colors (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(20) UNIQUE NOT NULL,
    hex VARCHAR(10) NOT NULL
);
GO

CREATE TABLE rewards (
    id INT IDENTITY(1,1) PRIMARY KEY,
    blob_name VARCHAR(255) NOT NULL,
    container_name VARCHAR(255) NOT NULL,
    starter BIT NOT NULL,
    trigger_type VARCHAR(50) CHECK (trigger_type IN ('task_completion', 'streak', 'path_completion')),
    trigger_value INT,
    color_id INT FOREIGN KEY REFERENCES colors(id)
);
GO

CREATE TABLE user_rewards (
    id INT IDENTITY(1,1) PRIMARY KEY,
    reward_id INT NOT NULL,
    user_id INT NOT NULL,
    date_awarded DATETIME2 NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (reward_id) REFERENCES rewards(id)
);
GO

CREATE TABLE avatar_state (
    id INT IDENTITY(1,1) PRIMARY KEY,
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
    beard VARCHAR(25) DEFAULT '0',
    updated_at DATETIME2 DEFAULT GETDATE()
);
GO
