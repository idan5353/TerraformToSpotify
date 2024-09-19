provider "random" {}

variable "artist" {
  description = "The name of the artist to create a playlist for"
  type        = string
}

variable "num_tracks" {
  description = "The number of tracks to add to each playlist"
  type        = number
  default     = 5
}

variable "unique_suffix" {
  description = "A unique suffix for the playlist to prevent name collisions"
  type        = string
}

variable "song_selection" {
  description = "Choose whether to get random songs or most popular songs"
  type        = string
}

# Data source for the specified artist
data "spotify_search_track" "search" {
  artist = var.artist
}

# Generate random integers to select random tracks
resource "random_integer" "random" {
  count = var.num_tracks
  min   = 0
  max   = length(data.spotify_search_track.search.tracks) - 1
}

# Create a local variable to hold selected tracks
locals {
  popular_tracks = slice(data.spotify_search_track.search.tracks, 0, var.num_tracks)

  random_tracks = [
    for i in random_integer.random : data.spotify_search_track.search.tracks[i.result]
  ]

  selected_tracks = var.song_selection == "popular" ? local.popular_tracks : local.random_tracks
}

# Create a playlist for the specified artist
resource "spotify_playlist" "artist_playlist" {
  name   = "${var.artist} Playlist - ${var.unique_suffix}"  # Unique name using the suffix
  public = false
  tracks = [for track in local.selected_tracks : track.id]
}
