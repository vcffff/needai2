import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:needai/main.dart';
import 'package:needai/data/services/firebase_services.dart';
import 'package:needai/presentation/themes/app_theme.dart';
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
  bool _isLoading = false;

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
    if (isLoggedIn && mounted) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainPage()),
        );
      }
    }
  }

  Future<void> signInWithGoogle() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        if (mounted) showSnackBar('Sign-in cancelled');
        setState(() => _isLoading = false);
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      final user = userCredential.user;
      if (user != null && user.email != null) {
        Provider.of<DataProvider>(context, listen: false).adduser(user.email!);
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isloggedin', true);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainPage()),
        );
      }
    } catch (e) {
      if (mounted) showSnackBar('Google Sign-In failed. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> registerButtonAction() async {
    if (_isLoading || !_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      final isRegistered = await Firebaseservices().register(
        email: email,
        password: password,
      );

      if (mounted && isRegistered) {
        final user = FirebaseAuth.instance.currentUser;

        if (user != null && user.email != null) {
          Provider.of<DataProvider>(
            context,
            listen: false,
          ).adduser(user.email!);
        }

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isloggedin', true);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainPage()),
        );
      } else if (mounted) {
        showSnackBar('Registration failed. Please try again.');
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        showSnackBar(_getFirebaseErrorMessage(e));
      }
    } catch (e) {
      if (mounted) {
        showSnackBar('An unexpected error occurred.');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> loginButtonAction() async {
    if (_isLoading || !_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
    
     

      final user = FirebaseAuth.instance.currentUser;

      if (mounted && user != null && user.email != null) {
        Provider.of<DataProvider>(context, listen: false).adduser(user.email!);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isloggedin', true);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainPage()),
        );
      } else if (mounted) {
        showSnackBar('Login failed. Please check your credentials.');
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        showSnackBar(_getFirebaseErrorMessage(e));
      }
    } catch (e) {
      if (mounted) {
        showSnackBar('An unexpected error occurred.');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  String _getFirebaseErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'invalid-email':
        return 'Invalid email format.';
      case 'weak-password':
        return 'Password is too weak.';
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      default:
        return 'An error occurred. Please try again.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          Column(
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
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Email', style: TextStyle(fontSize: 15)),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                hintText: 'Enter your email',
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                  horizontal: 16,
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
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Password',
                              style: TextStyle(fontSize: 15),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                hintText: 'Enter your password',
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                  horizontal: 16,
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
                                    setState(
                                      () => _obscureText = !_obscureText,
                                    );
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
                                  _isLoading
                                      ? null
                                      : widget.isSigned
                                      ? loginButtonAction
                                      : registerButtonAction,
                              style: FilledButton.styleFrom(
                                backgroundColor: AppTheme.primary,
                                minimumSize: const Size(double.infinity, 60),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                widget.isSigned ? 'Log In' : 'Sign Up',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Divider(color: AppTheme.divider),
                            const SizedBox(height: 20),
                            Center(
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : signInWithGoogle,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(16),
                                  shape: const CircleBorder(),
                                  elevation: 0,
                                  backgroundColor: Colors.white,
                                  foregroundColor: AppTheme.primary,
                                ),
                                child: Image.asset(
                                  'assets/images/google_icon.webp',
                                  width: 24,
                                  height: 24,
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
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(color: AppTheme.primary),
              ),
            ),
        ],
      ),
    );
  }
}
