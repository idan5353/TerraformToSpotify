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

# Data source for the specified artist
data "spotify_search_track" "search" {
  artist = var.artist
}

# Create a playlist for the specified artist
resource "spotify_playlist" "artist_playlist" {
  name   = "${var.artist} Playlist - ${var.unique_suffix}"  # Unique name using the suffix
  public = false
  tracks = [
    for i in range(var.num_tracks) : data.spotify_search_track.search.tracks[i].id
  ]
}