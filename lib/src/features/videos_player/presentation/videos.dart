import 'package:flutter/material.dart';
import 'package:needai/src/features/themes/colors.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('videos2').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          return ListView.separated(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            separatorBuilder:
                (BuildContext context, index) => SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_downward, color: lighttext, size: 25),
                    ],
                  ),
                ),
            itemCount: docs.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final data = docs[index].data();
              final url = data['video'] ?? '';
              final videoId = YoutubePlayerController.convertUrlToId(url) ?? '';

              if (videoId.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text("That link is not working"),
                );
              }

              final controller = YoutubePlayerController.fromVideoId(
                videoId: videoId,
                params: const YoutubePlayerParams(
                  showControls: true,
                  showFullscreenButton: true,

                  mute: false,
                ),
              );

              return Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: 300,
                    width: 500,
                    color: Colors.black,
                    child: YoutubePlayer(controller: controller),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
