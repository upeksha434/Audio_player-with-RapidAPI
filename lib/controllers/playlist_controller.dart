import 'dart:convert';

import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';


class PlaylistModel {
  final String playlistName;
  final List<String> songUris;

  PlaylistModel({required this.playlistName, required this.songUris});
}


class PlaylistController extends GetxController {
  RxList<PlaylistModel> playlists = <PlaylistModel>[].obs;

  //Load playlists from local storage
  // Future<void> loadPlaylists() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final playlistData = prefs.getString('playlists');
  //
  //   if (playlistData != null) {
  //     final List<dynamic> decodedPlaylists = json.decode(playlistData);
  //     playlists.value = decodedPlaylists
  //         .map((playlist) => PlaylistModel.fromJson(playlist))
  //         .toList()
  //         .obs;
  //   }
  // }

  // Save playlists to local storage
  Future<void> savePlaylists() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('playlists', json.encode(playlists));
  }

  // Create a new playlist
  void createPlaylist(String playlistName) {
    final newPlaylist = PlaylistModel(playlistName: playlistName, songUris: []);
    playlists.add(newPlaylist);
    savePlaylists();
  }

  // Add a song to a playlist
  // void addToPlaylist(int playlistIndex, String songUri) {
  //   if (playlistIndex >= 0 && playlistIndex < playlists.length) {
  //     final playlist = playlists[playlistIndex];
  //     playlist.songUris.add(songUri);
  //     savePlaylists();
  //   }
  // }
}
