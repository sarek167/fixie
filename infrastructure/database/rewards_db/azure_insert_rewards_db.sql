-- Wybierz bazę
USE rewards_db;
GO

-- Kolory
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
  ('skin8', '#6C3D2D'),
  ('lipstick1', '#CC6464'),
  ('lipstick2', '#AD4C44'),
  ('lipstick3', '#BD5C57'),
  ('lipstick4', '#963B3B'),
  ('lipstick5', '#6E2721'),
  ('blush1', '#D9776A'),
  ('blush2', '#FA7069'),
  ('blush3', '#FA8C73'),
  ('blush4', '#C25151'),
  ('blush5', '#873D3C'),
  ('purple', '#745C96'),
  ('white', '#C5B6A0'),
  ('blonde', '#B0815A'),
  ('copper', '#A1624F'),
  ('emerald', '#2A5C4E'),
  ('lilac', '#A382B8'),
  ('navy', '#49486E'),
  ('turquoise', '#4A7378');
GO

-- Starterowe nagrody
INSERT INTO rewards (blob_name, container_name, starter, trigger_type, trigger_value, color_id) VALUES
-- skin
('1', 'base', 1, NULL, NULL, 15),
('2', 'base', 1, NULL, NULL, 16),
('3', 'base', 1, NULL, NULL, 17),
('4', 'base', 1, NULL, NULL, 18),
('5', 'base', 1, NULL, NULL, 19),
('6', 'base', 1, NULL, NULL, 20),
('7', 'base', 1, NULL, NULL, 21),
('8', 'base', 1, NULL, NULL, 22),
-- hair starter
('braids-black', 'hair', 1, NULL, NULL, 1),
('bob-black', 'hair', 1, NULL, NULL, 1),
('braids-blonde', 'hair', 1, NULL, NULL, 35),
('bob-blonde', 'hair', 1, NULL, NULL, 35),
('braids-copper', 'hair', 1, NULL, NULL, 36),
('bob-copper', 'hair', 1, NULL, NULL, 36),
('braids-pink', 'hair', 1, NULL, NULL, 12),
('bob-pink', 'hair', 1, NULL, NULL, 12),
-- eyes starter
('black', 'eyes', 1, NULL, NULL, 1),
('blue', 'eyes', 1, NULL, NULL, 3),
('light_blue', 'eyes', 1, NULL, NULL, 4),
('brown', 'eyes', 1, NULL, NULL, 2),
('dark_brown', 'eyes', 1, NULL, NULL, 5),
('light_brown', 'eyes', 1, NULL, NULL, 6),
('green', 'eyes', 1, NULL, NULL, 7),
('dark_green', 'eyes', 1, NULL, NULL, 8),
('light_green', 'eyes', 1, NULL, NULL, 9),
-- top clothes starter
('basic-black', 'top-clothes', 1, NULL, NULL, 1),
('spaghetti-black', 'top-clothes', 1, NULL, NULL, 1),
('sailor-black', 'top-clothes', 1, NULL, NULL, 1),
('basic-blue', 'top-clothes', 1, NULL, NULL, 3),
('spaghetti-blue', 'top-clothes', 1, NULL, NULL, 3),
('sailor-blue', 'top-clothes', 1, NULL, NULL, 3),
('basic-light_green', 'top-clothes', 1, NULL, NULL, 9),
('spaghetti-light_green', 'top-clothes', 1, NULL, NULL, 9),
('sailor-light_green', 'top-clothes', 1, NULL, NULL, 9),
-- bottom clothes starter
('pants-black', 'bottom-clothes', 1, NULL, NULL, 1),
('pants-blue', 'bottom-clothes', 1, NULL, NULL, 3),
('pants-light_green', 'bottom-clothes', 1, NULL, NULL, 9),
-- lipstick starter
('1', 'lipstick', 1, NULL, NULL, 23),
('2', 'lipstick', 1, NULL, NULL, 24),
('3', 'lipstick', 1, NULL, NULL, 25),
-- blush starter
('1', 'blush', 1, NULL, NULL, 28),
('2', 'blush', 1, NULL, NULL, 29),
('3', 'blush', 1, NULL, NULL, 30),
-- beard starter
('blonde', 'beard', 1, NULL, NULL, 35),
('copper', 'beard', 1, NULL, NULL, 36),
('copper', 'beard', 1, NULL, NULL, 36),
-- eyes task completion
('grey', 'eyes', 0, 'task_completion', 5, 10),
('light_grey', 'eyes', 0, 'task_completion', 1, 11),
('pink', 'eyes', 0, 'task_completion', 2, 12),
-- eyes path completion
('light_pink', 'eyes', 0, 'path_completion', 5, 13),
('red', 'eyes', 0, 'path_completion', 6, 14),
-- hair path completion
('buzzcut-black', 'hair', 0, 'path_completion', 1, 1),
-- hair task completion
('wavy-black', 'hair', 0, 'task_completion', 22, 1),
-- hair streak
('curly-black', 'hair', 0, 'streak', 1, 1);
GO

-- Przypisanie nagród użytkownikowi
INSERT INTO user_rewards (reward_id, user_id) VALUES
(20, 6),
(21, 6),
(22, 6);
GO
