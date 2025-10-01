import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import '../main.dart'; // Assuming 'mq' is defined here
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Enable full-screen mode first for a smoother transition
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    // After a delay, navigate to the HomeScreen
    Future.delayed(const Duration(milliseconds: 2500), () {
      // Revert the system UI to default if needed, or keep edgeToEdge
      // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
      Get.off(() => const HomeScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size and assign to 'mq' (assuming 'mq' is a global variable)
    mq = MediaQuery.of(context).size;

    return Scaffold(
      // Set the background color for a cleaner look
      backgroundColor: Colors.white, // Or a primary color like Colors.green.shade50
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // --- Logo/App Icon ---
            // Increased the logo size and added an example icon.
            // Replace with your actual app logo image/asset.
            Icon(
              Icons.security_rounded,
              size: mq.width * 0.4, // Make it relative to screen width
              color: Colors.green.shade700,
            ),
            
            const SizedBox(height: 30),

            // --- App Title ---
            Text(
              'Secure VPN', // Updated text for a professional feel
              style: TextStyle(
                color: Colors.green.shade800,
                fontWeight: FontWeight.w900, // Very bold
                fontSize: 30, // Larger font size
              ),
            ),

            const SizedBox(height: 10),

            // --- Subtitle/Tagline ---
            Text(
              'Protect your privacy online',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
      
      // --- Progress Indicator and Footer using Align/Padding for better positioning ---
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: mq.height * 0.05), // Space from the bottom
        child: Column(
          mainAxisSize: MainAxisSize.min, // Keep column size minimal
          children: [
            // --- Loading Indicator ---
            SizedBox(
              width: mq.width * 0.5, // Constrain width of the loading bar
              child: LinearProgressIndicator(
                backgroundColor: Colors.green.shade100,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade700),
                minHeight: 4,
              ),
            ),
            
            const SizedBox(height: 20),

            // --- Footer/Branding Text ---
            const Text(
              'MADE IN INDIA WITH ❤️',
              textAlign: TextAlign.center,
              style: TextStyle(
                letterSpacing: 1.5,
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
