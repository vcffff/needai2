import 'package:flutter/material.dart';
import 'package:needai/features/auth/presentation/auth.dart';
import 'package:needai/core/themes/app_theme.dart';
import 'package:needai/core/providers/data_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                children: List.generate(4, (int index) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(words[index]),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.arrow_forward_ios_outlined),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                    ],
                  );
                }),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("exit"),
                      IconButton(
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Authourization(),
                            ),
                          );
                          final boolean = prefs.setBool("isloggedin", false);
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
        ),
      ),
    );
  }
}
