USE tasks_db;
GO

CREATE TABLE tasks (
    id INT IDENTITY(1,1) PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    category VARCHAR(100),
    difficulty INT,
    type VARCHAR(50),
    date_for_daily DATE NULL,
    answer_type VARCHAR(20) NOT NULL CHECK (answer_type IN ('text', 'checkbox')),
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE()
);
GO

CREATE TABLE paths (
    id INT IDENTITY(1,1) PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    image_url VARCHAR(500),
    color_hex CHAR(7),
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE()
);
GO

CREATE TABLE task_path (
    id INT IDENTITY(1,1) PRIMARY KEY,
    task_id INT NOT NULL,
    path_id INT NOT NULL,
    FOREIGN KEY (task_id) REFERENCES tasks(id) ON DELETE CASCADE,
    FOREIGN KEY (path_id) REFERENCES paths(id) ON DELETE CASCADE
);
GO

CREATE TABLE user_task_answers (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    task_id INT NOT NULL,
    text_answer TEXT,
    checkbox_answer BIT,
    status VARCHAR(50) NOT NULL CHECK (status IN ('in_progress', 'completed')),
    answered_at DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (task_id) REFERENCES tasks(id) ON DELETE CASCADE
);
GO

CREATE TABLE popular_paths (
    id INT IDENTITY(1,1) PRIMARY KEY,
    path_id INT NOT NULL,
    FOREIGN KEY (path_id) REFERENCES paths(id) ON DELETE CASCADE
);
GO

CREATE TABLE user_paths (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    path_id INT NOT NULL,
    started_at DATETIME2 DEFAULT GETDATE(),
    completed_at DATETIME2 NULL,
    updated_at DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (path_id) REFERENCES paths(id) ON DELETE CASCADE
);
GO
