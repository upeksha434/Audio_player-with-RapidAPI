import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/views/addsongs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/playlist_controller.dart';

class PlayList extends StatelessWidget {
  const PlayList({Key? key}) : super(key: key);

  //String newPlaylistName = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Playlist Creator',
      home: PlaylistScreen(),
    );
  }
}

class PlaylistScreen extends StatefulWidget {
  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  List<String> playlists = []; // List to store playlist names

  @override
  void initState() {
    super.initState();
    loadPlaylists(); // Load existing playlists from local storage
  }

  void loadPlaylists() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      playlists = prefs.getStringList('playlists') ?? [];
    });
    // OnTap: () {
    //   Get.to(AddSongs(data: playlists[index]));
    // };
  }

  void savePlaylists() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('playlists', playlists);
  }

  void showCreatePlaylistDialog(BuildContext context) {
    String newPlaylistName = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create Playlist'),
          content: TextFormField(
            decoration: InputDecoration(labelText: 'Playlist Name'),
            onChanged: (value) {
              newPlaylistName = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (newPlaylistName.isNotEmpty) {
                  setState(() {
                    playlists.add(newPlaylistName); // Add playlist to the list
                  });
                  savePlaylists(); // Save playlists to local storage
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
              child: Text('Create'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Playlists'),
      ),
      body: ListView.builder(
        itemCount: playlists.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(playlists[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showCreatePlaylistDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

