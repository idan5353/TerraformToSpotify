# 🎵 Spotify Playlist Creator

This Terraform project allows users to create a Spotify playlist based on a specified artist. It dynamically fetches tracks associated with the artist and generates a playlist containing those tracks.

## 🌟 Features

- **Dynamic Playlist Creation**: The playlist name is automatically generated based on the artist's name.
- **Track Retrieval**: The project uses the Spotify API to search for and retrieve tracks from the specified artist.
- **Customizable Artist Input**: Users can easily change the artist by modifying a single variable.

## 📜 Code Overview

### 🔧 Variables

- **`artist`**: The name of the artist for whom the playlist will be created. The default is set to "Eyal Golan".

### 📊 Data Sources

- **`spotify_search_track`**: This data source fetches tracks based on the artist's name provided in the variable.

### 📂 Resources

- **`spotify_playlist`**: This resource creates a playlist with the top six tracks retrieved from the search results.

## 🚀 Usage

1. Set up your environment with Terraform and the required Spotify API key.
2. Update the `artist` variable in the Terraform configuration if you want to create a playlist for a different artist.
3. Run `terraform init` to initialize the project.
4. Execute `terraform apply` to create the playlist on Spotify.

## 🤝 Contributing

Feel free to fork the repository and submit pull requests for enhancements or bug fixes!
