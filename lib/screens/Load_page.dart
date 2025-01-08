import 'package:flutter/material.dart';
import 'package:chamberplant/screens/screen.dart'; // Import WelcomePage

class LoadingScreen extends StatelessWidget {
  final Future<void> initializeApp;

  LoadingScreen({required this.initializeApp});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: initializeApp,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text(
                    'Loading...',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(
                'Connection Failed: ${snapshot.error}',
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
            ),
          );
        } else {
          Future.microtask(() {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => WelcomePage()),
            );
          });
          return SizedBox.shrink(); // ไม่แสดงอะไรขณะเปลี่ยนหน้า
        }
      },
    );
  }
}
