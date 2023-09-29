import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

import '../views/home.dart';

class PlayerController extends GetxController{
  final OnAudioQuery audioQuery = OnAudioQuery(); //from onaudioquery package to querysongs, albums, playlists etc
  final Player = AudioPlayer(); //from audioplayer package to play audio

  var playindex=0.obs;
  var isPlaying=false.obs;


  var duration =''.obs;
  var position =''.obs;
  @override
  void onInit() {
    super.onInit();
    IsPermissionAllowed();
  }

  updatePosition(){
    Player.positionStream.listen((event) {
      position.value=event.toString().split('.')[0].substring(2);
    });
    Player.durationStream.listen((event) {
      duration.value=event.toString().split('.')[0].substring(2);
    });
  }


  playSong(String? uri,index) async {
    playindex.value=index;
    try{

      Player.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
      Player.play();
      isPlaying(true);
      updatePosition();

    }
    catch(e){
      print(e.toString());
    }

  }

  pauseSong(){
    Player.pause();
    isPlaying(false);
  }


}

IsPermissionAllowed() async {
  var permissionStatus = await Permission.storage.request();
  if (permissionStatus.isGranted) {
//permission granted
  }else{
    IsPermissionAllowed();
  }

}

// import 'package:flutter/material.dart';
// import 'package:on_audio_query/on_audio_query.dart';
//
// import '../views/player.dart';
//
// void main() {
//   runApp(
//     const MaterialApp(
//       home: Songs(),
//     ),
//   );
// }
//
// class Songs extends StatefulWidget {
//   const Songs({Key? key}) : super(key: key);
//
//   @override
//   _SongsState createState() => _SongsState();
// }
//
// class _SongsState extends State<Songs> {
//   // Main method.
//   final OnAudioQuery _audioQuery = OnAudioQuery();
//
//   // Indicate if application has permission to the library.
//   bool _hasPermission = false;
//
//   @override
//   void initState() {
//     super.initState();
//     // (Optinal) Set logging level. By default will be set to 'WARN'.
//     //
//     // Log will appear on:
//     //  * XCode: Debug Console
//     //  * VsCode: Debug Console
//     //  * Android Studio: Debug and Logcat Console
//     LogConfig logConfig = LogConfig(logType: LogType.DEBUG);
//     _audioQuery.setLogConfig(logConfig);
//
//     // Check and request for permission.
//     checkAndRequestPermissions();
//   }
//
//   checkAndRequestPermissions({bool retry = false}) async {
//     // The param 'retryRequest' is false, by default.
//     _hasPermission = await _audioQuery.checkAndRequest(
//       retryRequest: retry,
//     );
//
//     // Only call update the UI if application has all required permissions.
//     _hasPermission ? setState(() {}) : null;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//             appBar: AppBar(
//
//         backgroundColor: Colors.black,
//         actions: [
//
//           IconButton(
//             onPressed: (){},
//             icon: Icon(IconData(0xf013d, fontFamily: 'MaterialIcons')),
//             color: Colors.white,
//           ),],
//          leading:const Icon(Icons.menu,color: Colors.white,),
//
//        title: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//            Text('All',style: TextStyle(fontFamily: 'zen koku gothic antique',fontSize: 20,fontWeight: FontWeight.bold,color:Colors.white),),
//             Text(' | ',style: TextStyle(fontFamily: 'zen koku gothic antique',fontSize: 20,fontWeight: FontWeight.bold,color:Colors.white),),
//
//             GestureDetector(
//               onTap:(){
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const Player()),
//                 );
//               }, child: Text('Album',style: TextStyle(fontFamily: 'zen koku gothic antique',fontSize: 20,fontWeight: FontWeight.bold,color:Colors.white)),
//             ),
//             ],
//        ),
//         centerTitle: true,
//
//       ),
//       body: Center(
//         child: !_hasPermission
//             ? noAccessToLibraryWidget() : FutureBuilder<List<SongModel>>(
//           // Default values:
//           future: _audioQuery.querySongs(
//             sortType: null,
//             orderType: OrderType.ASC_OR_SMALLER,
//             uriType: UriType.EXTERNAL,
//             ignoreCase: true,
//           ),
//           builder: (context, item) {
//             // Display error, if any.
//             if (item.hasError) {
//               return Text(item.error.toString());
//             }
//
//             // Waiting content.
//             if (item.data == null) {
//               return const CircularProgressIndicator();
//             }
//
//             // 'Library' is empty.
//             if (item.data!.isEmpty) return const Text("Nothing found!");
//
//             // You can use [item.data!] direct or you can create a:
//             // List<SongModel> songs = item.data!;
//             // return ListView.builder(
//             //   itemCount: item.data!.length,
//             //   itemBuilder: (context, index) {
//             //     return ListTile(
//             //       title: Text(item.data![index].title),
//             //       subtitle: Text(item.data![index].artist ?? "No Artist"),
//             //       trailing: const Icon(Icons.arrow_forward_rounded),
//             //       // This Widget will query/load image.
//             //       // You can use/create your own widget/method using [queryArtwork].
//             //       leading: QueryArtworkWidget(
//             //         controller: _audioQuery,
//             //         id: item.data![index].id,
//             //         type: ArtworkType.AUDIO,
//             //       ),
//             //     );
//             //   },
//             // );
//
//
//             return Container(
//               decoration:BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Color(0xff0f2151), Colors.black],
//                     stops: [0.6, 0.9],
//                     begin: Alignment.bottomCenter,
//                     end: Alignment.topCenter,
//                   )
//
//               ),
//               child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: ListView.builder(
//                       physics: const BouncingScrollPhysics(),
//                       itemCount:item.data!.length,
//                       itemBuilder:(BuildContext context, int index,){
//                         return Material(
//                           color: Colors.transparent,
//                           child: Container(
//
//                               margin: const EdgeInsets.all(8),
//                               decoration:BoxDecoration(
//                                 color: Colors.white.withOpacity(0.2),
//                                 borderRadius: BorderRadius.circular(10),),
//
//                               child:ListTile(
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.all(Radius.circular(10)),),
//
//
//                                 title: Text(item.data![index].displayNameWOExt,style: TextStyle(fontFamily: 'zen koku gothic antique',fontSize: 15,fontWeight: FontWeight.bold,color:Colors.white),),//get the song name
//
//                                 subtitle: Text("${item.data![index].artist}",style:TextStyle(fontFamily: 'zen koku gothic antique',fontSize: 12,color:Colors.white),),//get the artist name
//
//                                   leading: QueryArtworkWidget(
//                                   controller: _audioQuery,
//                                  id: item.data![index].id,
//                                  type: ArtworkType.AUDIO,
//                                     nullArtworkWidget: const Icon(
//                                       Icons.music_note,
//                                       color: Colors.white,
//                                     )
//                                ),
//                                 trailing: Icon(
//                                   Icons.play_arrow,
//                                   color: Colors.white,size:30,
//                                 ),
//                                 //tileColor: Colors.red,
//                                 onTap: (){
//
//                                 },
//
//
//                               )
//                           ),
//                         );
//                       }
//                   )
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget noAccessToLibraryWidget() {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         color: Colors.redAccent.withOpacity(0.5),
//       ),
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const Text("Application doesn't have access to the library"),
//           const SizedBox(height: 10),
//           ElevatedButton(
//             onPressed: () => checkAndRequestPermissions(retry: true),
//             child: const Text("Allow"),
//           ),
//         ],
//       ),
//     );
//   }
// }