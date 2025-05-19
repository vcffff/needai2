import 'package:flutter/material.dart';
import 'package:needai/providers/data_provider.dart';
import 'package:provider/provider.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({super.key});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  @override
  Widget build(BuildContext context) {
    final users = Provider.of<DataProvider>(context).users;
    return Scaffold(body: Center(child: Text('Hello, ${users[0]}')));
  }
}
