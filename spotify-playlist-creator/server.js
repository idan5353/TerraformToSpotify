const express = require('express');
const bodyParser = require('body-parser');
const { exec } = require('child_process');
const path = require('path');
const app = express();
const PORT = 3000;

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.static('public')); // Serve static files from the "public" directory

app.get('/', (req, res) => {
    sendForm(res, '');
});

let playlistCounter = 1; // Counter for unique suffixes

app.post('/create-playlist', (req, res) => {
    const artist = req.body.artist;
    const numTracks = req.body.num_tracks;
    const uniqueSuffix = `${Date.now()}-${playlistCounter++}`; // Create a unique suffix

    const tfDirectory = path.join(__dirname);

    exec(`terraform apply -var="artist=${artist}" -var="num_tracks=${numTracks}" -var="unique_suffix=${uniqueSuffix}" -auto-approve`, { cwd: tfDirectory }, (error, stdout, stderr) => {
        if (error) {
            console.error(`exec error: ${error}`);
            return sendForm(res, 'Error creating playlist');
        }

        // Extract playlist URL from stdout if possible
        const playlistUrlMatch = stdout.match(/https:\/\/open\.spotify\.com\/playlist\/[a-zA-Z0-9]+/);
        const playlistUrl = playlistUrlMatch ? playlistUrlMatch[0] : '';

        const message = playlistUrl ? 
            `Playlist created for ${artist} with ${numTracks} tracks! <a href="${playlistUrl}">View Playlist</a>` :
            `Playlist created for ${artist} with ${numTracks} tracks!`;

        sendForm(res, message);
    });
});

// Function to send the form with an optional message
function sendForm(res, message) {
    res.send(`
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Create Spotify Playlist</title>
            <link rel="stylesheet" href="/styles.css">
        </head>
        <body>
            <div class="container">
                <h1>Create Your Spotify Playlist</h1>
                ${message ? `<p>${message}</p>` : ''}
                <form action="/create-playlist" method="POST">
                    <label for="artist">Artist Name:</label>
                    <input type="text" name="artist" required placeholder="Enter artist name">
                    
                    <label for="num_tracks">Number of Tracks:</label>
                    <input type="number" name="num_tracks" min="1" max="30" required placeholder="Enter number of tracks">
                    
                    <input type="submit" value="Create Playlist">
                </form>
            </div>
        </body>
        </html>
    `);
}

app.listen(PORT, () => {
    console.log(`Server is running at http://localhost:${PORT}`);
});
