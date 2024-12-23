/*
This data includes my Spotify streaming history from September 2016 until the second week of May 2023
I received the raw data from Spotify and then worked on it until it was proper to work with. 
The original files were sent as JSON files, which I transformed into CSV files and finally joined everything into one single Excel file.
Then, I imported the file into SQL Server and started querying to find different insights from my music listening habits.
*/

-- To show all the data I received
SELECT *
FROM SpotifyProject..SpotifyStreamingHistory


-- To show the data for one of my favorite artists

SELECT *
FROM SpotifyProject..SpotifyStreamingHistory
WHERE artist_name = 'Bjork'



--Counting the times I've played one of my favorite artists

SELECT COUNT(artist_name)
FROM SpotifyProject..SpotifyStreamingHistory
WHERE artist_name = 'Bjork'



--Showing the TOP 25 of artists and ordering them by the amount of times I've played their songs

SELECT TOP 25 artist_name, COUNT(artist_name) as number_of_plays, SUM(min_played) as time_listened
FROM SpotifyProject..SpotifyStreamingHistory
GROUP BY artist_name
ORDER BY number_of_plays DESC



--Showing the TOP 25 of albums and ordering them by the amount of times I've played their songs

SELECT TOP 25 artist_name, album_name, COUNT(album_name) as number_of_plays, SUM(min_played) as time_listened
FROM SpotifyProject..SpotifyStreamingHistory
GROUP BY artist_name, album_name
ORDER BY number_of_plays DESC



--Showing the TOP 25 of tracks (also showing the artists who perform them and the albums where they appear) and ordering them by the amount of times I've played their songs

SELECT TOP 25 artist_name, album_name, track_name, COUNT(track_name) as number_of_plays, SUM(min_played) as time_listened
FROM SpotifyProject..SpotifyStreamingHistory
GROUP BY artist_name, album_name, track_name
ORDER BY number_of_plays DESC

--Showing the top albums by a specific artist and sorting them by the amount of plays each album has.

SELECT artist_name, album_name, COUNT(album_name) as number_of_plays, SUM(min_played) as time_listened
FROM SpotifyProject..SpotifyStreamingHistory
--WHERE artist_name = 'Bjork'
GROUP BY artist_name, album_name
ORDER BY number_of_plays DESC

--Showing the top songs by a specific album and sorting them by the amount of plays each album has.

SELECT artist_name, album_name, track_name, COUNT(track_name) as number_of_plays, SUM(min_played) as time_listened
FROM SpotifyProject..SpotifyStreamingHistory
WHERE album_name = 'Oncle Jazz'
GROUP BY artist_name, album_name, track_name
ORDER BY number_of_plays DESC


--Showing only artists whose songs have been played for at least a thousand times

SELECT artist_name, COUNT(artist_name) as number_of_plays, SUM(min_played) as time_listened
FROM SpotifyProject..SpotifyStreamingHistory
GROUP BY artist_name
HAVING COUNT(artist_name) >= 1000
ORDER BY number_of_plays DESC



--Showing the amount of songs played by year since I started using Spotify

SELECT year, COUNT(artist_name) as number_of_plays, SUM(min_played) as time_listened
FROM SpotifyProject..SpotifyStreamingHistory
GROUP BY year
ORDER BY number_of_plays DESC

-----

--Showing the amount of songs played by different plaforms (Web Player, Windows 7, Windows 10, Windows 11, Android or iOS)

SELECT platform, COUNT(platform) as plays_by_platform
FROM SpotifyProject..SpotifyStreamingHistory
GROUP BY platform
ORDER BY plays_by_platform DESC

--Showing the amount of songs that played when suffle mode was on

SELECT shuffle, COUNT(shuffle) as number_of_plays
FROM SpotifyProject..SpotifyStreamingHistory
GROUP BY shuffle
ORDER BY number_of_plays DESC

--Showing all the columns in the database where shuffle mode was on

SELECT *
FROM SpotifyProject..SpotifyStreamingHistory
WHERE shuffle = 'true'
