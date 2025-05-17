import 'package:flutter/material.dart';
import 'splash.dart'; // Import the Splash screen
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Your Firebase options file
import 'package:get/get.dart';
import 'home.dart'; // Import Home screen after Splash
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth import
import 'package:google_sign_in/google_sign_in.dart'; // Import Google Sign-In package

void main() async {
  // Ensure the widget binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with options for the current platform (Android/iOS)
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Doclink',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 80, 84, 203),
        ),
      ),
      // Set Splash as the initial screen
      home: const Splash(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> signInWithGoogle() async {
    try {
      print("Starting Google Sign-In...");
      // Start the Google Sign-In process
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print("Google sign-in was canceled.");
        return null; // The user canceled the sign-in
      }

      // Obtain the authentication details
      print("Google sign-in successful, fetching authentication...");
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create Firebase credentials
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with Firebase using the credentials
      print("Signing in with Firebase...");
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      final User? user = userCredential.user;
      print("Firebase sign-in successful: ${user?.displayName}");
      return user;
    } catch (e) {
      print("Google sign-in failed: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Google Sign-In")),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            print("Initiating Google Sign-In...");
            User? user = await signInWithGoogle();
            if (user != null) {
              print("Successfully signed in as: ${user.displayName}");
              // Navigate to the next screen (e.g., Home)
            } else {
              print("Google Sign-In failed");
            }
          },
          child: const Text("Sign in with Google"),
        ),
      ),
    );
  }
}
