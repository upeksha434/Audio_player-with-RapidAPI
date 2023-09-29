import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../controllers/player_controller.dart';


class Player extends StatelessWidget {
  //const Player({Key? key}) : super(key: key);
  final List< SongModel> data;
  const Player({Key? key, required this.data});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<PlayerController>();
    return Scaffold(


      //backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.black,
          statusBarIconBrightness: Brightness.light,
        ),


        backgroundColor: Colors.black.withOpacity(0.2),
        toolbarHeight: 35,
        elevation: 0,
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

            // GestureDetector(
            //   onTap:(){
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => const Player()),
            //     );
            //   }, child: Text('Album',style: TextStyle(fontFamily: 'zen koku gothic antique',fontSize: 20,fontWeight: FontWeight.bold,color:Colors.white)),
            // ),
          ],
        ),
        centerTitle: true,

      ),



      
      body:SingleChildScrollView(

        child: Container(

          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff0c0a21),Color(0xff0f2b7c), Colors.black],
                stops: [0.0,0.6, 0.9],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              )
          ),
          child: Obx(()=>
             Column(

              children: [
                Container(
                  clipBehavior: Clip.hardEdge,
                  height: MediaQuery.of(context).size.height*0.5,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    shape: BoxShape.values[0],
                  ),
                  child:ClipRRect(
                      borderRadius: BorderRadius.zero,
                      child:QueryArtworkWidget(
                        id: data[controller.playindex.value].id,
                        artworkBorder: BorderRadius.zero,
                        type: ArtworkType.AUDIO,
                        artworkHeight: double.infinity,
                        artworkWidth: double.infinity,
                        //artworkBlendMode: BlendMode.darken,
                        nullArtworkWidget: Container(
                          height: double.infinity,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.white.withOpacity(0.4),
                          ),
                          child: Icon(Icons.music_note,color: Colors.black,size: 50,),
                        ),

                      )
                  )),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      children:[
                        Text(
                          data[controller.playindex.value].displayNameWOExt,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          data[controller.playindex.value].artist.toString(),
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 20,),

                        Row(children: [
                          // Text("0.1",
                          // style: TextStyle(
                          //     fontSize: 15,
                          //     color: Colors.white,
                          //   ),
                          // ),
                          Expanded(
                            child:SleekCircularSlider(
                              appearance: CircularSliderAppearance(
                                size:350,
                                infoProperties: InfoProperties(
                                  mainLabelStyle: TextStyle(
                                    fontSize: 15,
                                    color: Colors.red,
                                  ),
                                ),
                                startAngle: 220,
                                angleRange: 100,
                                customColors: CustomSliderColors(
                                  progressBarColors: [Colors.white,Colors.pink],
                                  trackColor: Colors.grey,
                                  dotColor: Colors.white,
                                ),

                                customWidths: CustomSliderWidths(
                                  progressBarWidth: 2,
                                  trackWidth: 2,
                                  handlerSize: 5,
                                ),

                              ),
                              min:0,
                              max:100,
                               initialValue: 0,
                              onChange: (double value){

                               },
                              onChangeStart: (double startValue){
                                //double angle = 180;
                              },
                              innerWidget: (double value){


                                return Container(
                                  alignment: Alignment.center,
                                  width: double.infinity,

                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 80.0),
                                    child: Column(
                                      //mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Obx(()=>
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(controller.position.value,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(controller.duration.value ,style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white,
                                              ),
                                              textAlign: TextAlign.center,),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            IconButton(onPressed: (){
                                              controller.playSong(data[controller.playindex.value-1].uri, controller.playindex.value-1);

                                            }, icon: const Icon(IconData(0xf0193, fontFamily: 'MaterialIcons'),color: Colors.white,size: 35,)),
                                            Obx(()=>Container(
                                              child: IconButton(onPressed: (){
                                                if(controller.isPlaying.value){
                                                  controller.pauseSong();
                                                  controller.isPlaying(false);
                                                }
                                                else{
                                                  controller.Player.play();
                                                  controller.isPlaying(true);
                                                }

                                              }, icon:controller.isPlaying.value? const Icon(IconData(0xf0054, fontFamily: 'MaterialIcons'),color: Colors.white,size: 45,):
                                               const Icon(IconData(0xf00a3, fontFamily: 'MaterialIcons'),color: Colors.white,size: 45,)),
                                            ),),
                                            IconButton(onPressed: (){
                                              controller.playSong(data[controller.playindex.value+1].uri, controller.playindex.value+1);

                                            }, icon: const Icon(IconData(0xf0192, fontFamily: 'MaterialIcons'),color: Colors.white,size: 35,)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )

                                );
                              },
                            )
                          )

                        ],

                        )


                      ]
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
