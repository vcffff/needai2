import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:needai/main.dart';
import 'package:needai/data/services/firebase_services.dart';
import 'package:needai/presentation/screens/firstpage/firstpage.dart';
import 'package:needai/presentation/themes/app_theme.dart';
import 'package:needai/presentation/themes/colors.dart';
import 'package:needai/providers/data_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogOrSign extends StatefulWidget {
  final bool isSigned;
  const LogOrSign({super.key, required this.isSigned});

  @override
  State<LogOrSign> createState() => _LogOrSignState();
}

class _LogOrSignState extends State<LogOrSign> {
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isloggedin') ?? false;
    if (isLoggedIn) {
      showDialog(
        context: context,
        builder:
            (_) => const Center(
              child: CircularProgressIndicator(color: AppTheme.primary),
            ),
        barrierDismissible: false,
      );
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        Navigator.pop(context); // Dismiss loading dialog
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainPage()),
        );
      }
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      showDialog(
        context: context,
        builder:
            (_) => const Center(
              child: CircularProgressIndicator(color: AppTheme.primary),
            ),
        barrierDismissible: false,
      );
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Sign-in aborted.')));
        }
        return;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isloggedin', true);
      if (googleUser.email.isNotEmpty) {
        Provider.of<DataProvider>(
          context,
          listen: false,
        ).adduser(googleUser.email);
      }
      if (mounted) {
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainPage()),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Google Sign-In failed. Please try again.'),
          ),
        );
      }
    }
  }

  Future<void> registerButtonAction() async {
    if (_formKey.currentState!.validate()) {
      try {
        showDialog(
          context: context,
          builder:
              (_) => const Center(
                child: CircularProgressIndicator(color: AppTheme.primary),
              ),
          barrierDismissible: false,
        );
        String email = _emailController.text.trim();
        String password = _passwordController.text.trim();
        bool isRegistered = await Firebaseservices().register(
          email: email,
          password: password,
        );
        if (mounted) {
          Navigator.pop(context);
          if (isRegistered) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool('isloggedin', true);
            Provider.of<DataProvider>(context, listen: false).adduser(email);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainPage()),
            );
            print(Provider.of<DataProvider>(context).users);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Registration failed. Please try again.'),
              ),
            );
          }
        }
      } on FirebaseAuthException catch (e) {
        if (mounted) {
          Navigator.pop(context);
          String message;
          switch (e.code) {
            case 'email-already-in-use':
              message = 'This email is already registered.';
              break;
            case 'invalid-email':
              message = 'Invalid email format.';
              break;
            case 'weak-password':
              message = 'Password is too weak.';
              break;
            default:
              message = 'An error occurred. Please try again.';
          }
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
        }
      } catch (e) {
        print(e.toString());
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('An unexpected error occurred.')),
          );
        }
      }
    }
  }

  Future<void> loginButtonAction() async {
    if (_formKey.currentState!.validate()) {
      try {
        showDialog(
          context: context,
          builder:
              (_) => const Center(
                child: CircularProgressIndicator(color: AppTheme.primary),
              ),
          barrierDismissible: false,
        );
        String email = _emailController.text.trim();
        String password = _passwordController.text.trim();
        bool isLoggedIn = await Firebaseservices().authbyemail(
          email: email,
          password: password,
        );
        if (mounted) {
          Navigator.pop(context); // Dismiss loading dialog
          if (isLoggedIn) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool('isloggedin', true);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainPage()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Login failed. Please check your credentials.'),
              ),
            );
          }
        }
      } on FirebaseAuthException catch (e) {
        if (mounted) {
          Navigator.pop(context);
          String message;
          switch (e.code) {
            case 'user-not-found':
              message = 'No user found with this email.';
              break;
            case 'wrong-password':
              message = 'Incorrect password.';
              break;
            case 'invalid-email':
              message = 'Invalid email format.';
              break;
            default:
              message = 'An error occurred. Please try again.';
          }
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
        }
      } catch (e) {
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('An unexpected error occurred.')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            height: 150,
            color: AppTheme.background,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                widget.isSigned ? 'Log In' : 'Sign Up',
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.maxFinite,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Your Email',
                          style: TextStyle(fontSize: 15),
                        ),
                        const SizedBox(height: 3),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 18.0,
                              horizontal: 16.0,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: AppTheme.border,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: AppTheme.primary,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                            ).hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        const Text('Password', style: TextStyle(fontSize: 15)),
                        const SizedBox(height: 3),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 18.0,
                              horizontal: 16.0,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: AppTheme.border,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: AppTheme.primary,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        FilledButton(
                          onPressed:
                              widget.isSigned
                                  ? loginButtonAction
                                  : registerButtonAction,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            minimumSize: const Size(double.infinity, 60),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(widget.isSigned ? 'Log In' : 'Sign Up'),
                        ),
                        const SizedBox(height: 18),
                        const Divider(
                          color: AppTheme.divider,
                          height: 18,
                          thickness: 1,
                        ),
                        const SizedBox(height: 18),
                        Center(
                          child: SizedBox(
                            width: 60,
                            height: 60,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                shape: const CircleBorder(),
                              ),
                              onPressed: signInWithGoogle,
                              child: Image.asset(
                                'assets/images/google_icon.webp',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
