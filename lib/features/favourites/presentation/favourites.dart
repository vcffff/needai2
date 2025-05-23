import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:needai/core/themes/colors.dart';
import 'package:needai/features/videos_player/presentation/videos.dart';
import 'package:needai/core/providers/data_provider.dart';
import 'package:needai/core/providers/user_provider.dart';
import 'package:provider/provider.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<List<Color>> cardColors = [];
  List<Map<String, dynamic>> favoritesfromfirebase = [];

  @override
  void initState() {
    super.initState();
   loadfromfirebase();
  }

  Future<void>loadfromfirebase() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('favorites').get();
    setState(() {
      favoritesfromfirebase = snapshot.docs.map((doc) => doc.data()).toList();

      cardColors = List.generate(favoritesfromfirebase.length, (index) {
        final random = Random(index);
        final startColor = Color.fromRGBO(
          random.nextInt(256),
          random.nextInt(256),
          random.nextInt(256),
          0.8,
        );
        final endColor = Color.fromRGBO(
          random.nextInt(256),
          random.nextInt(256),
          random.nextInt(256),
          0.8,
        );
        return [startColor, endColor];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final favProvider = Provider.of<AddToFavourites>(context);


    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.favorite, color: maincolor),
        title: Text(
          'Favorites',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: lighttext,
          ),
        ),
        backgroundColor: bluecolor,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [gradient1, lighttext],
          ),
        ),
        child:
            favProvider.favourites.isEmpty
                ? Center(
                  child: Text(
                    'No favorites yet',
                    style: TextStyle(
                      fontSize: 20,
                      color: circlecolor,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                )
                : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GridView.builder(
                    itemCount: favProvider.favourites.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 15,
                          mainAxisExtent: 260,
                        ),
                    itemBuilder: (context, index) {
                      if (cardColors.length <= index) {
                        return const SizedBox.shrink();
                      }

                      final startColor = cardColors[index][0];
                      final endColor = cardColors[index][1];

                      return Card(
                        elevation: 8,
                        shadowColor: blackcolor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [startColor, endColor],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                // ignore: deprecated_member_use
                                color: maincolor.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${favProvider.favourites[index].title}",
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: lighttext,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 50),
                                LinearProgressIndicator(
                                  value:
                                      favoritesfromfirebase[index]['hours']! /
                                      24,
                                  // ignore: deprecated_member_use
                                  backgroundColor: lighttext.withOpacity(0.5),
                                  color: bluecolor,
                                  minHeight: 8,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                const SizedBox(height: 25),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Completed\n${favoritesfromfirebase[index]['hours']}/24',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: lighttext,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => SecondPage(),
                                          ),
                                        );
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: bluecolor,
                                        radius: 22,
                                        child: Icon(
                                          Icons.play_arrow,
                                          color: lighttext,
                                          size: 28,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
      ),
    );
  }
}
