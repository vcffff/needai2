import 'package:flutter/material.dart';
import 'package:needai/data/services/services.dart';
import 'package:needai/features/courses/presentation/coursePagedetail.dart';

class OneCourse extends StatelessWidget {
  static const Map<int, String> _courseImages = {
    2: 'https://ioe.hse.ru/data/2020/04/10/1557592905/2%D0%9F%D1%80%D0%B5%D0%B7%D0%B5%D0%BD%D1%82%D0%B0%D1%86%D0%B8%D1%8F2.jpg',
    3: 'https://grammar-tei.com/wp-content/uploads/2017/04/uroven-777x370.jpg',
    4: 'https://images.unsplash.com/photo-1547891654-e6758c0eb251?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60',
    5: 'https://w.wallhaven.cc/full/m3/wallhaven-m3kkrm.png',
    6: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTjDc8uYR-oODsIENsd9mMXJiyzIfBJcEQc_Q&s',
    7: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQixM17G9fo13lUm1Z6B2AcrCtY1G__-2ZEdQ&s',
  };

  final oneCourse onecourse;

  const OneCourse({super.key, required this.onecourse});

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        _courseImages[onecourse.id] ??
        'https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CoursePage(onecourse: onecourse),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  width: 110,
                  height: 110,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: 110,
                      height: 110,
                      color: Colors.grey[300],
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 110,
                      height: 110,
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image, size: 40),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      onecourse.title ?? 'Без названия',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${onecourse.hours ?? 0} часов',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
