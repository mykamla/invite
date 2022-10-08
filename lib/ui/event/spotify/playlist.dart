import 'package:myliveevent/constant/app_constants.dart';
import 'package:myliveevent/constant/spotify_constants.dart';
import 'package:spotify/spotify.dart';

class SpotifyPlaylist {

  var credentials = SpotifyApiCredentials(SpotifyConstants.idSpotify, SpotifyConstants.secretSpotify);

  Future<List<PlaylistSimple>> playlist(String search) async {
    var spotify = SpotifyApi(credentials);
    print('\nUser\'s playlists:');
    var usersPlaylists = await spotify.playlists.getUsersPlaylists(search).all();

    print('\nFeatured Playlist:');
    var featuredPlaylists = await spotify.playlists.featured.all();

    List<PlaylistSimple> totalPalylist = [];
    totalPalylist.addAll(usersPlaylists.toList());
    totalPalylist.addAll(featuredPlaylists.toList());

    return search.isNotEmpty ? totalPalylist : [];
  }

}

