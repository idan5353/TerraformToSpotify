variable "artists" {
  description = "List of artists to create playlists for"
  type        = list(string)
  default     = ["eminem", "ed sheeran", "adele"]  # Example artists
}

variable "num_tracks" {
  description = "The number of tracks to add to each playlist"
  type        = number
  default     = 5
}

# Create a playlist for each artist
resource "spotify_playlist" "artist_playlists" {
  for_each = toset(var.artists)

  name   = "${each.key} Playlist"
  tracks = [
    for i in range(var.num_tracks) : data.spotify_search_track.search[each.key].tracks[i].id
  ]
}

# Data source for each artist
data "spotify_search_track" "search" {
  for_each = toset(var.artists)

  artist = each.key
}
