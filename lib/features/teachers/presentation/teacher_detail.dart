import 'package:flutter/material.dart';
import 'package:needai/features/teachers/presentation/teacherchatpage.dart';

class TeacherDetailPage extends StatelessWidget {
  final Map<String, dynamic> teacher;

  const TeacherDetailPage({super.key, required this.teacher});

  void question(BuildContext context) {
    final TextEditingController questionController = TextEditingController();
    String? errorText;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                'Задать вопрос ${teacher['name'] ?? 'преподавателю'}',
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: questionController,
                    decoration: InputDecoration(
                      hintText: 'Введите ваш вопрос...',
                      errorText: errorText,
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Отмена', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (questionController.text.trim().isEmpty) {
                      setState(() {
                        errorText = 'Вопрос не может быть пустым';
                      });
                      return;
                    }
                    print(
                      'Вопрос к ${teacher['name'] ?? 'неизвестному'}: ${questionController.text}',
                    );
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Вопрос отправлен ${teacher['name'] ?? ''}',
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Отправить',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showBookingDialog(BuildContext context, Map<String, dynamic> teacher) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController timeController = TextEditingController();

    DateTime? selectedDate;
    TimeOfDay? selectedTime;
    String? errorText;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Записаться к ${teacher['name'] ?? 'преподавателю'}'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: 'Ваше имя',
                        errorText: errorText,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: 'Ваш email',
                        errorText: errorText,
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 8),
                    InkWell(
                      onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(Duration(days: 365)),
                        );

                        if (pickedDate != null) {
                          final TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );

                          if (pickedTime != null) {
                            setState(() {
                              selectedDate = pickedDate;
                              selectedTime = pickedTime;

                              final formattedDate =
                                  '${pickedDate.day}.${pickedDate.month}.${pickedDate.year}';
                              final formattedTime = pickedTime.format(context);

                              timeController.text =
                                  '$formattedTime, $formattedDate';
                            });
                          }
                        }
                      },
                      child: IgnorePointer(
                        child: TextField(
                          controller: timeController,
                          decoration: InputDecoration(
                            hintText: 'Выберите дату и время',
                            errorText: errorText,
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Отмена', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (nameController.text.trim().isEmpty ||
                        emailController.text.trim().isEmpty ||
                        timeController.text.trim().isEmpty) {
                      setState(() {
                        errorText = 'Все поля должны быть заполнены';
                      });
                      return;
                    }

                    print(
                      'Запись к ${teacher['name'] ?? 'неизвестному'}: Имя: ${nameController.text}, Email: ${emailController.text}, Время: ${timeController.text}',
                    );
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Запись к ${teacher['name'] ?? ''} отправлена',
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Отправить',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = teacher['name'] ?? 'Неизвестный преподаватель';
    final image = teacher['image'] ?? '';
    final description = teacher['description'] ?? 'Описание отсутствует.';
    final skills = teacher['skills'] ?? 'Нет данных о навыках.';
    final experience = teacher['experience'] ?? 'Нет данных об опыте.';

    return Scaffold(
      appBar: AppBar(title: Text(name), backgroundColor: Colors.blue),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: "persik",
              child: Stack(
                children: [
                  SizedBox(
                    height: 250,
                    width: double.infinity,
                    child:
                        image.isNotEmpty
                            ? Image.network(image, fit: BoxFit.cover)
                            : Container(color: Colors.grey[300]),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),

                  SizedBox(height: 16),
                  Text(
                    'О себе',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[800],
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Навыки',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 8),
                  Text(
                    skills,
                    style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                  ),

                  SizedBox(height: 16),
                  Text(
                    'Опыт',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 8),
                  Text(experience),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _showBookingDialog(context, teacher),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Записаться',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton(
                          onPressed:
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          TeacherChatPage(otherUserId: "1"),
                                ),
                              ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.blue),
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Задать вопрос',
                            style: TextStyle(fontSize: 16, color: Colors.blue),
                          ),
                        ),
                      ),
                    ],
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
