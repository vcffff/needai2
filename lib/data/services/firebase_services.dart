import 'package:firebase_auth/firebase_auth.dart';


class Firebaseservices {
  FirebaseAuth auth = FirebaseAuth.instance;
  Future<bool> authbyemail({
    required String email,
    required String password,
  }) async {
    

    bool islogined = false;
    try {
      final result = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      islogined = true;
      print(result);
    } catch (e) {
      print("Login failed: ${e.toString()}");
    }
    return islogined;
  }

  Future<void> resendpassword({required String email}) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      print("Password reset email sent.");
    } catch (e) {
      print("Password reset failed: ${e.toString()}");
    }
  }

  Future<bool> register({
    required String email,
    required String password,
  }) async {
    bool isauth = false;
    try {
      await auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      isauth = true;
      print('User registered successfully');
    } catch (e) {
      print("Registration failed: ${e.toString()}"); // Detailed error feedback
    }
    return isauth;
  }
}
