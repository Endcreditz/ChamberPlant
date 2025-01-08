import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';

import 'constants.dart';
import 'mqtt_manager.dart'; // Import MQTTManager
import 'package:chamberplant/screens/Load_page.dart'; // Import LoadingScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initial Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chamber Plant Project',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        scaffoldBackgroundColor: kBackgroundColor,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoadingScreen(
        initializeApp: initializeApp(), // เรียกใช้ Future สำหรับการโหลด
      ),
    );
  }

  /// ฟังก์ชันสำหรับการเริ่มต้นแอป
  Future<void> initializeApp() async {
    final mqttManager = MQTTManager();
    await mqttManager.connect(); // เรียก connect() จาก MQTTManager
  }
}
