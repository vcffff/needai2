import 'package:flutter/material.dart';
import 'package:needai/providers/data_provider.dart';
import 'package:provider/provider.dart';
import 'package:needai/presentation/themes/app_theme.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({super.key});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  @override
  Widget build(BuildContext context) {
    final users = Provider.of<DataProvider>(context).userEmail;
    List<String> words = [
      "Favourite",
      "Edit Account",
      "Setting and Privacy",
      "Help",
    ];

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        centerTitle: true,
        leading: Icon(Icons.person),
        title: Text(
          'Account',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
        ),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Padding(
          padding: EdgeInsets.all(17),
          child: Column(
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(
                          'assets/images/Avatarofperson.png',
                        ),
                        radius: 50,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(users ?? 'a@aaa.com'),
                ],
              ),
              SizedBox(height: 20),
              Column(
                children: [
                  for (int i = 0; i < 4; i++)
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(words[i]),
                            IconButton(
                              onPressed: () {

                              },
                              icon: Icon(Icons.arrow_forward_ios_outlined),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
     
    );
  }
}
