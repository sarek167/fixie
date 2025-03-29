-- Dodanie zadań
INSERT INTO tasks (title, description, category, difficulty, type)
VALUES
('3 rzeczy, za które jesteś dziś wdzięczny/a',
 'Zapisz 3 rzeczy, które dziś sprawiły Ci radość lub były dla Ciebie ważne.',
 'Wdzięczność', 2, 'daily'),

('Spacer na świeżym powietrzu',
 'Idź na minimum 15-minutowy spacer. Zwróć uwagę na to, co widzisz, słyszysz i czujesz.',
 'Mindfulness', 2, 'daily'),

('Ćwiczenie oddechowe 4-7-8',
 'Wdech przez 4 sekundy, zatrzymanie oddechu na 7 sekund, wydech przez 8 sekund. Powtórz 4 razy.',
 'Relaksacja', 1, 'daily'),

('Zrób coś miłego dla siebie',
 'Zrób jedną małą rzecz tylko dla siebie – może to być kawa, kąpiel, chwila ciszy, odcinek serialu.',
 'Self-care', 1, 'daily'),

('Zapisz swoje emocje z dzisiejszego dnia',
 'Usiądź spokojnie i przez 10 minut napisz, co dziś czujesz i co mogło na to wpłynąć.',
 'Journaling', 3, 'daily'),

('Wypróbuj nową aktywność',
 'Znajdź w internecie lub przypomnij sobie aktywność, której jeszcze nie próbowałeś/aś – i ją zrób.',
 'Nowe hobby', 3, 'path'),

('Wybacz sobie jedną rzecz',
 'Pomyśl o jednej rzeczy, która Ci nie wyszła, i spróbuj spojrzeć na siebie z wyrozumiałością.',
 'Akceptacja', 4, 'path'),

('Napisz list do przyszłego siebie',
 'Opisz, co czujesz teraz i czego życzysz sobie za rok. Zapisz go i schowaj.',
 'Refleksja', 3, 'path'),

('Zrób coś kreatywnego',
 'Narysuj coś, napisz krótki wiersz, ułóż kolaż – cokolwiek twórczego.',
 'Ekspresja', 2, 'path'),

('Dzień offline',
 'Spróbuj przez minimum 3 godziny nie korzystać z żadnych mediów społecznościowych.',
 'Detoks cyfrowy', 4, 'path'),

('Zadzwoń do bliskiej osoby',
 'Zadzwoń do kogoś, z kim dawno nie rozmawiałeś/aś. Nawet na chwilę.',
 'Relacje', 2, 'daily'),

('Medytacja z przewodnikiem',
 'Włącz krótką medytację prowadzoną (np. z YouTube) i poświęć na nią 10 minut.',
 'Mindfulness', 2, 'daily'),

('Zadbaj o sen',
 'Zaplanuj wieczór tak, by położyć się wcześniej. Unikaj ekranu min. 30 minut przed snem.',
 'Zdrowie fizyczne', 3, 'daily'),

('Zrób listę rzeczy, które lubisz w sobie',
 'Wypisz min. 5 rzeczy, które cenisz w sobie – cechy, umiejętności, zachowania.',
 'Poczucie własnej wartości', 4, 'path'),

('Napisz, co byś powiedział/a przyjacielowi w tej samej sytuacji',
 'Masz trudny dzień? Zapisz, co powiedział(a)byś bliskiej osobie, która czuje to samo.',
 'Współczucie do siebie', 3, 'path'),

('Ustal jedną małą rzecz, którą dziś zrobisz tylko dla siebie',
 'Nie musi być spektakularna – może to być chwila spokoju, ulubiona herbata, porządek na biurku.',
 'Self-care', 1, 'daily'),

('Zapisz swoje sukcesy z ostatniego tygodnia',
 'Nawet małe rzeczy – ukończone zadanie, sprzątnięcie pokoju, rozmowa z kimś.',
 'Motywacja', 2, 'daily');


-- Dodanie ścieżek
INSERT INTO paths (title, description, image_url, color_hex)
VALUES
('Ścieżka wdzięczności', 'Zestaw zadań pomagających zauważać pozytywne rzeczy wokół siebie.', NULL, '#F6D776'),
('Ścieżka uważności', 'Zadania skoncentrowane na rozwijaniu obecności tu i teraz.', 'https://picsum.photos/500/300?random=1', NULL),
('Ścieżka emocji', 'Pomaga rozumieć, nazywać i akceptować swoje emocje.', 'https://picsum.photos/500/300?random=2', NULL),
('Ścieżka rozwoju osobistego', 'Wyzwania, które wspierają rozwój i odkrywanie nowych pasji.', NULL, NULL);


-- Przypisania zadań do ścieżek
INSERT INTO task_path (task_id, path_id)
VALUES
(1, 1),
(2, 2),
(3, 2),
(5, 3),
(6, 4),
(7, 3),
(8, 3),
(9, 4),
(10, 2),
(11, 3),
(12, 2),
(13, 4),
(14, 3),
(15, 3),
(16, 1),
(17, 4);


-- Przypisania zadań do użytkownika
INSERT INTO user_tasks (user_id, task_id, status)
VALUES
(1, 1, 'completed'),
(1, 2, 'pending'),
(1, 3, 'completed'),
(1, 4, 'in_progress'),
(1, 5, 'pending');

INSERT INTO popular_paths (path_id)
VALUES
(1), -- Ścieżka wdzięczności
(3); -- Ścieżka emocji

INSERT INTO user_paths (user_id, path_id, completed_at)
VALUES
(1, 1, NULL),                          -- rozpoczęta, ale nieukończona
(1, 2, '2024-03-15 10:20:00'),         -- ukończona ścieżka uważności
(6, 3, NULL),                          -- w trakcie ścieżki emocji
(6, 4, '2024-03-20 18:45:00');    