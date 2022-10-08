import 'package:myliveevent/constant/app_constants.dart';
import 'package:myliveevent/constant/spotify_constants.dart';
import 'package:spotify/spotify.dart';


class Exemple {

  void m() async {
    var credentials = SpotifyApiCredentials(SpotifyConstants.idSpotify, SpotifyConstants.secretSpotify);
    var spotify = SpotifyApi(credentials);
    // var keyJson = await File('assets/spotify/api_keys.json').readAsString();
    // var keyMap = json.decode(keyJson);

    print('\nPodcast:');
    await spotify.shows.get('4rOoJ6Egrf8K2IrywzwOMk')
        .then((podcast) => print(podcast.name))
        .onError((error, stackTrace) => print((error as SpotifyException).message));

    print('\nPodcast episode:');
    var episodes = spotify.shows.episodes('4AlxqGkkrqe0mfIx3Mi7Xt');
    await episodes.first()
        .then((first) => print(first.items!.first))
        .onError((error, stackTrace) => print((error as SpotifyException).message));

    print('\nArtists:');
    var artists = await spotify.artists.list(['0OdUWJ0sBjDrqHygGUXeCF']);
    artists.forEach((x) => print(x.name));

    print('\nAlbum:');
    var album = await spotify.albums.get('2Hog1V8mdTWKhCYqI5paph');
    print(album.name);

    print('\nAlbum Tracks:');
    var tracks = await spotify.albums.getTracks(album.id!).all();
    tracks.forEach((track) {
      print(track.name);
    });

    print('\nFeatured Playlist:');
    var featuredPlaylists = await spotify.playlists.featured.all();
    featuredPlaylists.forEach((playlist) {
      print(playlist.name);
    });

    print('\nUser\'s playlists:');
    var usersPlaylists = await spotify.playlists.getUsersPlaylists('akon').all();
    usersPlaylists.forEach((playlist) {
      print(usersPlaylists.length);
      print(playlist);
    });

    print("\nSearching for \'Metallica\':");
    var search = await spotify.search
        .get('metallica')
        .first(2)
        .catchError((err) => print((err as SpotifyException).message));
    if (search == null) {
      return;
    }
    search.forEach((pages) {
      pages.items!.forEach((item) {
        if (item is PlaylistSimple) {
          print('Playlist: \n'
              'id: ${item.id}\n'
              'name: ${item.name}:\n'
              'collaborative: ${item.collaborative}\n'
              'href: ${item.href}\n'
              'trackslink: ${item.tracksLink!.href}\n'
              'owner: ${item.owner}\n'
              'public: ${item.owner}\n'
              'snapshotId: ${item.snapshotId}\n'
              'type: ${item.type}\n'
              'uri: ${item.uri}\n'
              'images: ${item.images!.length}\n'
              '-------------------------------');
        }
        if (item is Artist) {
          print('Artist: \n'
              'id: ${item.id}\n'
              'name: ${item.name}\n'
              'href: ${item.href}\n'
              'type: ${item.type}\n'
              'uri: ${item.uri}\n'
              '-------------------------------');
        }
        if (item is TrackSimple) {
          print('Track:\n'
              'id: ${item.id}\n'
              'name: ${item.name}\n'
              'href: ${item.href}\n'
              'type: ${item.type}\n'
              'uri: ${item.uri}\n'
              'isPlayable: ${item.isPlayable}\n'
              'artists: ${item.artists!.length}\n'
              'availableMarkets: ${item.availableMarkets!.length}\n'
              'discNumber: ${item.discNumber}\n'
              'trackNumber: ${item.trackNumber}\n'
              'explicit: ${item.explicit}\n'
              '-------------------------------');
        }
        if (item is AlbumSimple) {
          print('Album:\n'
              'id: ${item.id}\n'
              'name: ${item.name}\n'
              'href: ${item.href}\n'
              'type: ${item.type}\n'
              'uri: ${item.uri}\n'
              'albumType: ${item.albumType}\n'
              'artists: ${item.artists!.length}\n'
              'availableMarkets: ${item.availableMarkets!.length}\n'
              'images: ${item.images!.length}\n'
              'releaseDate: ${item.releaseDate}\n'
              'releaseDatePrecision: ${item.releaseDatePrecision}\n'
              '-------------------------------');
        }
      });
    });

    var relatedArtists =
    await spotify.artists.relatedArtists('0OdUWJ0sBjDrqHygGUXeCF');
    print('\nRelated Artists: ${relatedArtists.length}');

    credentials = await spotify.getCredentials();
    print('\nCredentials:');
    print('Client Id: ${credentials.clientId}');
    print('Access Token: ${credentials.accessToken}');
    print('Credentials Expired: ${credentials.isExpired}');
  }


}

