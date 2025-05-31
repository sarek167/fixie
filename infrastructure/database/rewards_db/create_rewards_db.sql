-- Tworzenie bazy danych
CREATE DATABASE rewards_db;

-- Użycie tej bazy
\c rewards_db;

-- Tworzenie typu ENUM dla trigger_type
CREATE TYPE trigger_type_enum AS ENUM (
    'task_completion',
    'streak',
    'path_completion'
);

-- Tworzenie tabeli rewards
CREATE TABLE rewards (
    id SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL,
    description TEXT NOT NULL,
    blob_name VARCHAR NOT NULL,
    container_name VARCHAR NOT NULL,
    trigger_type trigger_type_enum NOT NULL,
    trigger_value INTEGER NOT NULL
);

-- Tworzenie tabeli user_rewards
CREATE TABLE user_rewards (
    id SERIAL PRIMARY KEY,
    reward_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    date_awarded TIMESTAMP NOT NULL DEFAULT NOW(),
    FOREIGN KEY (reward_id) REFERENCES rewards(id)
);
