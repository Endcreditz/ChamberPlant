import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../screens/screen.dart';
//import '../screens/DHT_page.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Image(
                          image: AssetImage('assets/images/chamberplant.png'),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "CHAMBER PLANT.",
                      style: kHeadline,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "P R O J E C T.",
                      style: kHeadline,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        "โปรแกรมควบคุม ที่ใช้ควบคุมการเพาะเลี้ยงพืช และควบคุมการทำงานของระบบต่างๆภายในตู้.",
                        style: kBodyText,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: TextButton(
                          style: ButtonStyle(
                            overlayColor: MaterialStateProperty.resolveWith(
                              (states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return Colors.black12; // สีเมื่อกดปุ่ม
                                }
                                return null; // ไม่มีสีเมื่อไม่กด
                              },
                            ),
                          ),
                          onPressed: () {
                            // เพิ่มการทำงานเมื่อกดปุ่ม เช่น การนำทางไปยังหน้าถัดไป
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DHT_page(),
                              ),
                            );
                          },
                          child: Text(
                            'Lets Start',
                            style: kButtonText,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40), // เพิ่มระยะห่างจากขอบล่าง
            ],
          ),
        ),
      ),
    );
  }
}
