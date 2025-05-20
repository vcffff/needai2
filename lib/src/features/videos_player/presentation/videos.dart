import 'package:flutter/material.dart';
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
    final screenWidth = MediaQuery.of(context).size.width;
    final videoHeight = screenWidth * 9 / 16 + 40;

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Видео уроки')),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('videos2').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            physics: const BouncingScrollPhysics(),
            itemCount: docs.length,
            separatorBuilder: (context, index) => const SizedBox(height: 40),
            itemBuilder: (context, index) {
              final data = docs[index].data();
              final url = data['video'] ?? '';
              final videoId = YoutubePlayerController.convertUrlToId(url) ?? '';

              if (videoId.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text("Ссылка не работает"),
                );
              }

              final controller = YoutubePlayerController.fromVideoId(
                videoId: videoId,
                params: const YoutubePlayerParams(
                  showControls: true,
                  showFullscreenButton: true,
                  enableJavaScript: true,
                  strictRelatedVideos: true,
                ),
              );

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: videoHeight,
                    color: Colors.black,
                    child: YoutubePlayer(
                      controller: controller,
                      aspectRatio: 16 / 9,
                    ),
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
