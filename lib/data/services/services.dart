import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';

class SearchFill {
  String? title;
  String? image;
  final Color colour;
  SearchFill({required this.title, required this.image, required this.colour});
}

class oneCourse {
  int id;
  String? title;
  int? hours;
  String? type;
  List<CourseVideo> courseVideos;
  oneCourse({
    required this.id,
    required this.title,
    required this.hours,
    this.type,
    required this.courseVideos,
  });
  Map<String, dynamic> toJson() => {
    'title': title,
    'hours': hours,
    'type': type,
    'courseVideos': courseVideos.map((v) => v.toJson).toList(),
  };

  factory oneCourse.fromJson(Map<String, dynamic> json) => oneCourse(
    id: json['id'],
    title: json['title'],
    hours: json['hours'],
    type: json['type'],
    courseVideos:
        (json['courseVideos'] as List)
            .map((v) => CourseVideo.fromJson(v))
            .toList(),
  );
}

class CourseVideo {
  int? id;
  String? title;
  String? url;
  CourseVideo({required this.id, required this.title, required this.url});
  Map<String, dynamic> toJson() {
    return {'title': title, 'url': url};
  }

  factory CourseVideo.fromJson(Map<String, dynamic> json) {
    return CourseVideo(id: json['id'], title: json['title'], url: json['url']);
  }
}

List<oneCourse> originalCourses = [
  oneCourse(
    id: 0,
    title: 'Physics',
    hours: 18,
    type: 'New',
    courseVideos: [
      CourseVideo(
        id: 0,
        title: 'First Law of Newton',
        url: 'https://youtu.be/1XSyyjcEHo0?si=srPQWGpWns92k_VE',
      ),
      CourseVideo(
        id: 1,
        title: 'Second Law of Newton',
        url: 'https://youtu.be/xzA6IBWUEDE?si=_thMwcmpcHXgvVW9',
      ),
      CourseVideo(
        id: 2,
        title: 'Second Law of Newton',
        url: 'https://youtu.be/y61_VPKH2B4?si=f8vC5QV16nPJyHh6',
      ),
    ],
  ),
  oneCourse(
    id: 1,
    title: 'Math',
    hours: 20,
    type: 'Popular',
    courseVideos: [
      CourseVideo(
        id: 2,
        title: 'Kaprekar\'s constant',
        url: 'https://youtu.be/xtyNuOikdE4?si=TPiu3CMX9Khbc_Bv',
      ),
      CourseVideo(
        id: 3,
        title: 'Derivatives',
        url: 'https://youtu.be/N2PpRnFqnqY?si=Fg0e2mlyrvLCsZHE',
      ),
      CourseVideo(
        id: 4,
        title: 'Integral',
        url: 'https://youtu.be/nCx6FTChgow?si=4Wsa-5wr55G9CIen',
      ),
    ],
  ),
  oneCourse(
    id: 2,
    title: 'English',
    hours: 15,
    type: 'New',
    courseVideos: [
      CourseVideo(
        id: 0,
        title: 'Kaprekar\'s constant',
        url: 'https://youtu.be/xtyNuOikdE4?si=TPiu3CMX9Khbc_Bv',
      ),
      CourseVideo(
        id: 1,
        title: 'Derivatives',
        url: 'https://youtu.be/N2PpRnFqnqY?si=Fg0e2mlyrvLCsZHE',
      ),
      CourseVideo(
        id: 2,
        title: 'Integral',
        url: 'https://youtu.be/nCx6FTChgow?si=4Wsa-5wr55G9CIen',
      ),
    ],
  ),
  oneCourse(
    id: 2,
    title: 'Computer Science',
    hours: 28,
    type: 'New',
    courseVideos: [
      CourseVideo(
        id: 0,
        title: 'Introduction to Algorithms',
        url: 'https://youtu.be/xtyNuOikdE4?si=TPiu3CMX9Khbc_Bv',
      ),
      CourseVideo(
        id: 1,
        title: 'Data Structures: Arrays and Linked Lists',
        url: 'https://youtu.be/N2PpRnFqnqY?si=Fg0e2mlyrvLCsZHE',
      ),
      CourseVideo(
        id: 2,
        title: 'Basics of Object-Oriented Programming',
        url: 'https://youtu.be/nCx6FTChgow?si=4Wsa-5wr55G9CIen',
      ),
    ],
  ),
  oneCourse(
    id: 3,
    title: 'Astronomy',
    hours: 24,
    type: 'New',
    courseVideos: [
      CourseVideo(
        id: 0,
        title: 'The Solar System: Planets and Moons',
        url: 'https://youtu.be/xtyNuOikdE4?si=TPiu3CMX9Khbc_Bv',
      ),
      CourseVideo(
        id: 1,
        title: 'Stellar Evolution: Birth and Death of Stars',
        url: 'https://youtu.be/N2PpRnFqnqY?si=Fg0e2mlyrvLCsZHE',
      ),
      CourseVideo(
        id: 2,
        title: 'The Big Bang and Cosmology',
        url: 'https://youtu.be/nCx6FTChgow?si=4Wsa-5wr55G9CIen',
      ),
    ],
  ),
  oneCourse(
    id: 4,
    title: 'Art History',
    hours: 20,
    type: 'New',
    courseVideos: [
      CourseVideo(
        id: 0,
        title: 'Renaissance Art: Masters and Techniques',
        url: 'https://youtu.be/xtyNuOikdE4?si=TPiu3CMX9Khbc_Bv',
      ),
      CourseVideo(
        id: 1,
        title: 'Impressionism and Modern Art',
        url: 'https://youtu.be/N2PpRnFqnqY?si=Fg0e2mlyrvLCsZHE',
      ),
      CourseVideo(
        id: 2,
        title: 'Introduction to Drawing and Painting',
        url: 'https://youtu.be/nCx6FTChgow?si=4Wsa-5wr55G9CIen',
      ),
    ],
  ),
  oneCourse(
    id: 5,
    title: 'Kinematic Physics Essentials',
    hours: 22,
    type: 'New',
    courseVideos: [
      CourseVideo(
        id: 0,
        title: 'Motion in One Dimension',
        url: 'https://youtu.be/xtyNuOikdE4?si=TPiu3CMX9Khbc_Bv',
      ),
      CourseVideo(
        id: 1,
        title: 'Vectors and Two-Dimensional Motion',
        url: 'https://youtu.be/N2PpRnFqnqY?si=Fg0e2mlyrvLCsZHE',
      ),
      CourseVideo(
        id: 2,
        title: 'Projectile Motion and Circular Motion',
        url: 'https://youtu.be/nCx6FTChgow?si=4Wsa-5wr55G9CIen',
      ),
    ],
  ),
];
