
  
CREATE TABLE genres (
    genre_id INTEGER PRIMARY KEY,
    genre_name TEXT NOT NULL
);

INSERT INTO genres (genre_name)
VALUES 
    ('Pop'),
    ('Alternative'),
    ('R&B'),
    ('Hip-Hop');

CREATE TABLE artists (
    artist_id INTEGER PRIMARY KEY,
    artist_name TEXT NOT NULL
);

INSERT INTO artists (artist_name)
VALUES 
    ('The Weeknd'),
    ('Billie Eilish'),
    ('Lady Gaga'),
    ('Adele');

CREATE TABLE albums (
    album_id INTEGER PRIMARY KEY,
    album_name TEXT NOT NULL,
    artist_id INTEGER NOT NULL,
    release_date DATE,

    FOREIGN KEY (artist_id)
        REFERENCES artists(artist_id)
);

INSERT INTO albums (album_name, artist_id, release_date)
VALUES 
    ('After Hours', 1, '2020-03-20'),
    ('HIT ME HARD AND SOFT', 2, '2024-05-17'),
    ('Born This Way', 3, '2011-05-23'),
    ('PRIMA', 4, '2026-09-04');

CREATE TABLE songs (
    song_id INTEGER PRIMARY KEY,
    song_title TEXT NOT NULL,
    album_id INTEGER NOT NULL,
    genre_id INTEGER NOT NULL,
    duration_seconds INTEGER,

    FOREIGN KEY (album_id)
        REFERENCES albums(album_id),

    FOREIGN KEY (genre_id)
        REFERENCES genres(genre_id)
);

INSERT INTO songs(song_title, album_id, genre_id, duration_seconds)
VALUES 
    ('Blinding Lights', 1, 3, 288),
    ('Birds of a Feather', 2, 1, 210),
    ('Born This Way', 3, 1, 200),
    ('PRIMA', 4, 1, 198);

CREATE TABLE users (
    user_id INTEGER PRIMARY KEY,
    username TEXT NOT NULL UNIQUE,
    email TEXT NOT NULL UNIQUE
);
INSERT INTO users(username, email)
VALUES 
('Linda', 'Linda@example.com');

--SELECT * FROM users; --

CREATE TABLE playlists (
    playlist_id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    playlist_name TEXT NOT NULL,
    created_date DATE NOT NULL,

    FOREIGN KEY (user_id)
        REFERENCES users(user_id)
);

INSERT INTO playlists (user_id,playlist_name, created_date)
VALUES
(1, 'Favorites', '2026-10-01'),
(1, 'Study', '2026-10-02'),
(1, 'Gym', '2026-10-03');

--SELECT * FROM playlists;--


CREATE TABLE playlist_songs (
    playlist_id INTEGER NOT NULL,
    song_id INTEGER NOT NULL,

    PRIMARY KEY (playlist_id, song_id),

    FOREIGN KEY (playlist_id)
        REFERENCES playlists(playlist_id),

    FOREIGN KEY (song_id)
        REFERENCES songs(song_id)
);
INSERT INTO playlist_songs(playlist_id, song_id)
VALUES 
(1,1),
(1,2),
(1,4),
(2,1),
(2,3),
(2,2),
(3,2),
(3,4);

--SELECT * FROM playlist_songs;--


CREATE TABLE listening_history (
    history_id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    song_id INTEGER NOT NULL,
    played_at DATETIME NOT NULL,

    FOREIGN KEY (user_id)
        REFERENCES users(user_id),

    FOREIGN KEY (song_id)
        REFERENCES songs(song_id)
);

INSERT INTO listening_history (user_id, song_id, played_at)
VALUES 
(1, 1, '2026-10-01 18:00:00'),
(1, 1, '2026-10-01 18:05:00'),
(1, 2, '2026-10-01 18:10:00'),
(1, 3, '2026-10-01 18:15:00'),
(1, 1, '2026-10-01 18:20:00');

--SELECT * FROM listening_history;--

SELECT * FROM genres;
SELECT * FROM artists;
SELECT * FROM albums;
SELECT * FROM songs;
SELECT * FROM users;
SELECT * FROM playlists;
SELECT * FROM playlist_songs;
SELECT * FROM listening_history;


--SONGS IN EACH PLAYLIST--
SELECT playlists.playlist_name, songs.song_title
FROM playlists
JOIN playlist_songs
ON playlists.playlist_id = playlist_songs.playlist_id
JOIN songs  
ON playlist_songs.song_id = songs.song_id;


--MOST PLAYED SONG--
SELECT songs.song_title, 
COUNT (listening_history.song_id) AS play_count
FROM listening_history
JOIN songs
ON listening_history.song_id = songs.song_id
GROUP BY songs.song_id, songs.song_title
ORDER BY play_count DESC;


--MOST LISTENED TO ARTIST--
SELECT artists.artist_name,
COUNT (listening_history.song_id) AS play_count
FROM listening_history
JOIN songs
ON listening_history.song_id = songs.song_id
JOIN albums 
ON songs.album_id = albums.album_id
JOIN artists
ON albums.artist_id = artists.artist_id
GROUP BY artists.artist_id, artists.artist_name
ORDER BY play_count DESC;

--MOST LISTENED  TO GENRE--
SELECT  
genres.genre_name,
COUNT (listening_history.song_id) AS play_count
FROM listening_history
JOIN songs
ON listening_history.song_id = songs.song_id
JOIN genres
ON songs.genre_id = genres.genre_id
GROUP BY genres.genre_id, genres.genre_name
ORDER BY play_count DESC;

  
--Linda's playlist with artists--
SELECT 
users.username, playlists.playlist_name, songs.song_title, artists.artist_name
FROM users
JOIN playlists
ON users.user_id = playlists.user_id
JOIN playlist_songs
ON playlists.playlist_id = playlist_songs.playlist_id
JOIN songs 
ON playlist_songs.song_id = songs.song_id
JOIN albums
ON songs.album_id = albums.album_id
JOIN artists
ON albums.artist_id = artists.artist_id
WHERE users.username =  'Linda'
ORDER BY playlists.playlist_name;
