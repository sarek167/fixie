-- Startery – użytkownik dostaje je od razu
USE rewards_db;

INSERT INTO rewards (name, description, blob_name, container_name, starter, trigger_type, trigger_value, color_to_display) VALUES
('skin1', 'Skin tone 1', '1', 'base', TRUE, NULL, NULL, '#E6AC9C'),
('skin2', 'Skin tone 2', '2', 'base', TRUE, NULL, NULL, '#DEA48A'),
('skin3', 'Skin tone 3', '3', 'base', TRUE, NULL, NULL, '#DE9A85'),
('skin4', 'Skin tone 4', '4', 'base', TRUE, NULL, NULL, '#EB9C7A'),
('skin5', 'Skin tone 5', '5', 'base', TRUE, NULL, NULL, '#AB6E4D'),
('skin6', 'Skin tone 6', '6', 'base', TRUE, NULL, NULL, '#96553E'),
('skin7', 'Skin tone 7', '7', 'base', TRUE, NULL, NULL, '#784C31'),
('skin8', 'Skin tone 8', '8', 'base', TRUE, NULL, NULL, '#6C3D2D'),
('braids-black', 'Braids image in black', '8', 'hair', TRUE, NULL, NULL, '#000000'),
('bob-black', 'Braids in black', '8', 'hair', TRUE, NULL, NULL, '#000000');
-- ('starter_shirt', 'Podstawowa koszulka dostępna od początku.', 'starter_shirt.png', 'avatars', TRUE, NULL, NULL, '#CCCCCC'),
-- ('starter_pet', 'Twój pierwszy towarzysz!', 'starter_pet.png', 'avatars', TRUE, NULL, NULL, '#CCCCCC');

-- Nagrody za zadania, streaki, ścieżki
-- INSERT INTO rewards (name, description, blob_name, container_name, starter, trigger_type, trigger_value, color_to_display) VALUES
-- ('task_hat', 'Nagroda za wykonanie pierwszego zadania.', 'task_hat.png', 'avatars', FALSE, 'task_completion', 1, '#FFD700'),
-- ('streak5_shoes', 'Buty za 5 dni z rzędu zadań.', 'streak5_shoes.png', 'avatars', FALSE, 'streak', 5, '#00FF00'),
-- ('path_jacket', 'Kurtka za ukończenie ścieżki „Samopoznanie”.', 'path_jacket.png', 'avatars', FALSE, 'path_completion', 1, '#1E90FF');
