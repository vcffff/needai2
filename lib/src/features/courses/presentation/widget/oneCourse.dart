import 'package:flutter/material.dart';
import 'package:needai/src/data/services/services.dart';
import 'package:needai/src/features/courses/presentation/coursePagedetail.dart';

class OneCourse extends StatelessWidget {
  static const Map<int, String> _courseImages = {
    2: 'https://images.unsplash.com/photo-1516321310762-479437144403?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60',
    3: 'https://images.unsplash.com/photo-1462331940025-496dfbfc7564?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60',
    4: 'https://images.unsplash.com/photo-1547891654-e6758c0eb251?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60',
    5: 'https://w.wallhaven.cc/full/m3/wallhaven-m3kkrm.png',
    6: 'https://w.wallhaven.cc/full/6l/wallhaven-6lj876.png',
    7: 'https://w.wallhaven.cc/full/6l/wallhaven-6lj876.png',
  };

  final oneCourse onecourse;

  const OneCourse({super.key, required this.onecourse});

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        _courseImages[onecourse.id] ??
        'https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60';

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CoursePage(onecourse: onecourse),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                  // Handle image loading errors
                  onError: (exception, stackTrace) {
                    print(
                      'Error loading image for course ${onecourse.id}: $exception',
                    );
                  },
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    onecourse.title ?? 'No Title',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.amber[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Text(
                      '${onecourse.hours ?? 0} hours',
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
