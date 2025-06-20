-- Startery – użytkownik dostaje je od razu
USE rewards_db;

INSERT INTO colors (name, hex) VALUES
  ('black', '#000000'),
  ('brown', '#4D3530'),
  ('blue', '#354652'),
  ('light_blue', '#546E8A'),
  ('dark_brown', '#2E2723'),
  ('light_brown', '#754B44'),
  ('green', '#475C4E'),
  ('dark_green', '#24382D'),
  ('light_green', '#637D64'),
  ('grey', '#544B4E'),
  ('light_grey', '#6E656A'),
  ('pink', '#B04F63'),
  ('light_pink', '#C26576'),
  ('red', '#A64444'),
  ('skin1', '#E6AC9C'),
  ('skin2', '#DEA48A'),
  ('skin3', '#DE9A85'),
  ('skin4', '#EB9C7A'),
  ('skin5', '#AB6E4D'),
  ('skin6', '#96553E'),
  ('skin7', '#784C31'),
  ('skin8', '#6C3D2D');


INSERT INTO rewards (blob_name, container_name, starter, trigger_type, trigger_value, color_id) VALUES
('1', 'base', TRUE, NULL, NULL, 14),
('2', 'base', TRUE, NULL, NULL, 15),
('3', 'base', TRUE, NULL, NULL, 16),
('4', 'base', TRUE, NULL, NULL, 17),
('5', 'base', TRUE, NULL, NULL, 18),
('6', 'base', TRUE, NULL, NULL, 19),
('7', 'base', TRUE, NULL, NULL, 20),
('8', 'base', TRUE, NULL, NULL, 21),
('braids-black', 'hair', TRUE, NULL, NULL, 22),
('bob-black', 'hair', TRUE, NULL, NULL, 22),
('black', 'eyes', TRUE, NULL, NULL, 22),
('blue', 'eyes', TRUE, NULL, NULL, 2),
('light_blue', 'eyes', TRUE, NULL, NULL, 3),
('brown', 'eyes', TRUE, NULL, NULL, 1),
('dark_brown', 'eyes', TRUE, NULL, NULL, 4),
('light_brown', 'eyes', TRUE, NULL, NULL, 5),
('green', 'eyes', TRUE, NULL, NULL, 6),
('dark_green', 'eyes', TRUE, NULL, NULL, 7),
('light_green', 'eyes', TRUE, NULL, NULL, 8),
('grey', 'eyes', FALSE, 'task_completion', 5, 9),
('light_grey', 'eyes', FALSE, 'task_completion', 1, 10),
('pink', 'eyes', FALSE, 'task_completion', 2, 11),
('light_pink', 'eyes', FALSE, 'path_completion', 5, 12),
('red', 'eyes', FALSE, 'path_completion', 6, 13);
-- ('starter_shirt', 'Podstawowa koszulka dostępna od początku.', 'starter_shirt.png', 'avatars', TRUE, NULL, NULL, '#CCCCCC'),
-- ('starter_pet', 'Twój pierwszy towarzysz!', 'starter_pet.png', 'avatars', TRUE, NULL, NULL, '#CCCCCC');

-- Nagrody za zadania, streaki, ścieżki
-- INSERT INTO rewards (name, description, blob_name, container_name, starter, trigger_type, trigger_value, color_to_display) VALUES
-- ('grey eyes', 'Nagroda za wykonanie pięciu zadań', 'grey', 'eyes', FALSE, 'task_completion', 1, '#FFD700'),
-- ('streak5_shoes', 'Buty za 5 dni z rzędu zadań.', 'streak5_shoes.png', 'avatars', FALSE, 'streak', 5, '#00FF00'),
-- ('path_jacket', 'Kurtka za ukończenie ścieżki „Samopoznanie”.', 'path_jacket.png', 'avatars', FALSE, 'path_completion', 1, '#1E90FF');

INSERT INTO user_rewards (reward_id, user_id) VALUES
(20, 6),
(21, 6),
(22, 6);