import 'package:flutter/material.dart';
import 'package:needai/presentation/screens/auth/fore_auth_page.dart';

class Authourization extends StatefulWidget {
  const Authourization({super.key});

  @override
  State<Authourization> createState() => _AuthourizationState();
}

class _AuthourizationState extends State<Authourization> {
  @override
  Widget build(BuildContext context) {
    return FirstAuthorizationPage();
  }
}
