variable "artist" {
  description = "The name of the artist to create a playlist for"
  type        = string
  default     = "eminem"  # Default artist name
}

variable "num_tracks" {
  description = "The number of tracks to add to the playlist"
  type        = number
  default     = 10  # Default number of tracks
}

data "spotify_search_track" "search" {
  artist = var.artist
}

resource "spotify_playlist" "checkPlaylist" {
  name   = "${var.artist} Playlist"
  tracks = [
    for i in range(var.num_tracks) : data.spotify_search_track.search.tracks[i].id
  ]
}
