variable "artist" {
  description = "The name of the artist to create a playlist for"
  type        = string
  default     = "eyal golan"  # Default artist name
}

data "spotify_search_track" "search" {
  artist = var.artist
}

resource "spotify_playlist" "checkPlaylist" {
  name   = "${var.artist} Playlist"
  tracks = [
    data.spotify_search_track.search.tracks[0].id,
    data.spotify_search_track.search.tracks[1].id,
    data.spotify_search_track.search.tracks[2].id,
    data.spotify_search_track.search.tracks[3].id,
    data.spotify_search_track.search.tracks[4].id,
    data.spotify_search_track.search.tracks[5].id
  ]
}