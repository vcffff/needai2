import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:needai/data/services/services.dart';
import 'package:needai/presentation/screens/video_page/videos.dart';
import 'package:needai/presentation/themes/colors.dart';
import 'package:needai/providers/user_provider.dart';
import 'package:provider/provider.dart';

class CoursePage extends StatefulWidget {
  final oneCourse onecourse;

  const CoursePage({super.key, required this.onecourse});

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 10, top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close),
                  ),
                ),

                Text(
                  widget.onecourse.title!,
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.amber[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${widget.onecourse.hours} Hours',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 153, 66, 0),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: widget.onecourse.courseVideos.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    oneVideo(courseVideo: widget.onecourse.courseVideos[index]),
                    SizedBox(height: 10),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.amber,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: Size(double.infinity, 100),
                ),
                onPressed: () async {
                  final favProvider = Provider.of<AddToFavourites>(
                    context,
                    listen: false,
                  );
                  final isFav = favProvider.isFavourite(widget.onecourse);

                  if (isFav) {
                    favProvider.removeFromFav(widget.onecourse);
                  } else {
                    favProvider.addToFav(widget.onecourse);
                  }

                  await favProvider.savefav();
                  setState(() {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Successfully added"),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  });
                },

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Consumer<AddToFavourites>(
                      builder: (context, favProvider, _) {
                        final isFav = favProvider.isFavourite(widget.onecourse);
                        final courseId = widget.onecourse.id.toString();

                        return GestureDetector(
                          onTap: () async {
                            final docRef = FirebaseFirestore.instance
                                .collection('favorites')
                                .doc(courseId);

                            if (isFav) {
                              await docRef.delete();
                              favProvider.removeFromFav(widget.onecourse);
                            } else {
                              await docRef.set({
                                'id': widget.onecourse.id,
                                'title': widget.onecourse.title,
                                'hours': widget.onecourse.hours,
                              });
                              favProvider.addToFav(widget.onecourse);
                            }
                            print("docref:$docRef");
                            print("isfav:$isFav");
                            print("favprovider:$favProvider");
                          },
                          child: Icon(
                            isFav
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            size: 60,
                            color: isFav ? Colors.amber : Colors.grey,
                          ),
                        );
                      },
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: maincolor,
                      ),
                      onPressed: () {},
                      child: Text(
                        " Start now!",
                        style: TextStyle(
                          color: lighttext,
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class oneVideo extends StatelessWidget {
  final CourseVideo courseVideo;
  const oneVideo({super.key, required this.courseVideo});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),

      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Text(
                '0${courseVideo.id! + 1}',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Expanded(
              flex: 5,
              child: Text(
                courseVideo.title!,
                style: TextStyle(fontSize: 15),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SecondPage()),
                );
              },
              icon: Icon(
                Icons.play_circle_outline_rounded,
                size: 40,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
