import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/controllers/player_controller.dart';
import 'package:music_player/views/player.dart';
import 'package:music_player/views/playlist.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlayerController());



    return Scaffold(

      backgroundColor: Colors.transparent,
      //extendBodyBehindAppBar: true,
      appBar: AppBar(

        backgroundColor: Colors.black,
        actions: [

          IconButton(
            onPressed: (){},
            icon: Icon(IconData(0xf013d, fontFamily: 'MaterialIcons')),
            color: Colors.white,
          ),],
         leading:const Icon(Icons.menu,color: Colors.white,),

       title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
           Text('All',style: TextStyle(fontFamily: 'zen koku gothic antique',fontSize: 20,fontWeight: FontWeight.bold,color:Colors.white),),
            Text(' | ',style: TextStyle(fontFamily: 'zen koku gothic antique',fontSize: 20,fontWeight: FontWeight.bold,color:Colors.white),),

            GestureDetector(
              onTap:(){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PlayList()),
                );
              }, child: Text('Album',style: TextStyle(fontFamily: 'zen koku gothic antique',fontSize: 20,fontWeight: FontWeight.bold,color:Colors.white)),
            ),
            ],
       ),
        centerTitle: true,

      ),
      body:FutureBuilder<List<SongModel>>(
          future: controller.audioQuery.querySongs(
          ignoreCase: true,
          orderType: OrderType.ASC_OR_SMALLER,
          sortType:SongSortType.DATE_ADDED,
          uriType: UriType.EXTERNAL,
          ),
          builder:(BuildContext context, snapshot){

            if(snapshot.data==null){
              return Center(
                child:CircularProgressIndicator(),
              );
            }else if(snapshot.data!.isEmpty){
              return const Center(
                child: Text('No songs found'),
              );
            }else{
              //print(snapshot.data);
              return Container(
                decoration:BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xff0c0a21),Color(0xff0c2654),Color(0xff0c2654), Colors.black],
                      stops: [0.0,0.3,0.6, 0.9],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    )
                        //0xff0f2151

                ),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount:snapshot.data!.length,
                        itemBuilder:(BuildContext context, int index,){
                          return Material(
                            color: Colors.transparent,
                            child: Container(

                                margin: const EdgeInsets.all(8),
                                decoration:BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),

                                  borderRadius: BorderRadius.circular(10),

                                ),

                                child:Obx(()=>

                                  ListTile(
                                    enabled: true,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10)
                                      ),
                                    ),



                                    title: GestureDetector(
                                      onTap:(){
                                        Get.to(
                                              ()=>Player(data:snapshot.data!),
                                          transition: Transition.rightToLeftWithFade,
                                        );
                                        controller.playSong(snapshot.data![index].uri,index);
                                      },
                                        child: Text(snapshot.data![index].displayNameWOExt,style: TextStyle(fontFamily: 'zen koku gothic antique',fontSize: 15,fontWeight: FontWeight.bold,color:Colors.white),)),//get the song name
                                    subtitle: Text("${snapshot.data![index].artist}",style:TextStyle(fontFamily: 'zen koku gothic antique',fontSize: 12,color:Colors.white),),//get the artist name
                                    //string interpolation with $ used to include variables in string and subtitle should contain ${} to include variables
                                      leading: QueryArtworkWidget(
                                        id: snapshot.data![index].id,
                                        type: ArtworkType.AUDIO,
                                        nullArtworkWidget: const Icon(
                                          Icons.music_note,
                                          color: Colors.white,
                                        )
                                    ),
                                    trailing:controller.playindex.value==index && controller.isPlaying.value? const Icon(
                                      Icons.pause,
                                      color: Colors.white,
                                    ):const Icon(
                                      Icons.play_arrow,
                                      color: Colors.white,
                                    ),
                                    onTap:(){
                                      if(controller.playindex.value==index && controller.isPlaying.value){
                                        controller.pauseSong();
                                        return;
                                      }
                                      controller.playSong(snapshot.data![index].uri,index);
                                      AudioService.play();

                                    },



                                  ),
                                )
                            ),
                          );
                        }
                    )
                ),
              );
            }
          }
      )

    );
  }
}
