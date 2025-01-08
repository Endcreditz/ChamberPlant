import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../mqtt_manager.dart'; // เชื่อมต่อ MQTT
import './welcome_page.dart';
import './DHT_page.dart';
import './VL53L0X_page.dart';
import './TSL2561_page.dart';
import '../constants.dart';

class control_page3 extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final MQTTManager _mqttManager = MQTTManager();

  final TextEditingController _lightController = TextEditingController();
  final TextEditingController _lightController1 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
//ระบบแสง
              SizedBox(height: 40), //Light system
              Text(
                'Light System Control',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Status',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StreamBuilder<DocumentSnapshot>(
                    stream: _firestore
                        .collection('Sensors')
                        .doc('TSL2561')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      }
                      String light_intensity =
                          snapshot.data!['Light_Intensity'];
                      String h_on = snapshot.data!['Light_H_ON'];
                      String h_off = snapshot.data!['Light_H_OFF'];
                      String m_on = snapshot.data!['Light_M_ON'];
                      String m_off = snapshot.data!['Light_M_OFF'];
                      String infrared = snapshot.data!['Light_Infrared'];
                      String fullspectrum = snapshot.data!['Light_Spectrum'];

                      return Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start, // จัดข้อความชิดซ้าย
                        children: [
                          SizedBox(height: 10),
                          Text(
                            'ค่า Light Intensity : $light_intensity lux',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'ค่า Light Fullspectrum : $fullspectrum lux',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'ค่า Light Infrared : $infrared W/m²',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          // แสดงสถานะการทำงาน
                          Text(
                            'เวลาที่ตั้ง เปิดไฟ : $h_on:$m_on',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          // แสดงสถานะการทำงาน
                          Text(
                            'เวลาที่ตั้ง ปิดไฟ : $h_off:$m_off',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'โหมดควบคุมการทำงาน',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  StreamBuilder<DocumentSnapshot>(
                    stream: _firestore
                        .collection('Sensors')
                        .doc('TSL2561')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      }
                      // อ่านค่า Light_Manual_Mode จาก Firestore
                      var data10 = snapshot.data!;
                      int L_mode =
                          int.parse(data10['Light_Manual_Mode'] ?? "0");
                      return Row(
                        children: [
                          Text(
                            'AUTO',
                            style: TextStyle(color: Colors.white),
                          ),
                          Switch(
                              value: L_mode == 1, // ถ้า 1 = Manual, 0 = Auto
                              inactiveThumbColor:
                                  const Color.fromARGB(255, 255, 196, 0),
                              onChanged: null),
                          Text(
                            'Manual',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ควบคุมการทำงาน',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  StreamBuilder<DocumentSnapshot>(
                    stream: _firestore
                        .collection('Sensors')
                        .doc('TSL2561')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      }
                      // อ่านค่า LightSystem_State จาก Firestore
                      var data11 = snapshot.data!;
                      int L_state =
                          int.parse(data11['LightSystem_State'] ?? "0");
                      return Row(
                        children: [
                          Text(
                            'OFF',
                            style: TextStyle(color: Colors.white),
                          ),
                          Switch(
                              value: L_state == 1, // ถ้า 1 = ON, 0 = OFF
                              inactiveThumbColor:
                                  const Color.fromARGB(255, 224, 153, 0),
                              onChanged: null),
                          Text(
                            'ON',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
              Text(
                'Control',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'โหมดควบคุมการทำงาน',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  StreamBuilder<DocumentSnapshot>(
                    stream: _firestore
                        .collection('Sensors')
                        .doc('TSL2561')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      }
                      // อ่านค่า Light_Manual_Mode จาก Firestore
                      var data12 = snapshot.data!;
                      int L_mode =
                          int.parse(data12['Light_Manual_Mode'] ?? "0");
                      return Row(
                        children: [
                          Text(
                            'AUTO',
                            style: TextStyle(color: Colors.white),
                          ),
                          Switch(
                            value: L_mode == 1, // ถ้า 1 = Manual, 0 = Auto
                            activeColor: const Color.fromARGB(255, 255, 196, 0),
                            onChanged: (value) {
                              // เมื่อเปลี่ยนค่าให้ส่งข้อมูลไปยัง MQTT
                              if (value) {
                                // ส่ง 'L_OFF' เมื่อเปลี่ยนเป็น Manual
                                _mqttManager.sendMessage('L_OFF');
                                _firestore
                                    .collection('Sensors')
                                    .doc('TSL2561')
                                    .update({
                                  'Light_Manual_Mode': "1",
                                });
                              } else {
                                // ส่ง 'L_AUTO' เมื่อเปลี่ยนเป็น Auto
                                _mqttManager.sendMessage('L_AUTO');
                                _firestore
                                    .collection('Sensors')
                                    .doc('TSL2561')
                                    .update({
                                  'Light_Manual_Mode': "0",
                                });
                              }
                            },
                          ),
                          Text(
                            'Manual',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ควบคุมการทำงาน',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  StreamBuilder<DocumentSnapshot>(
                    stream: _firestore
                        .collection('Sensors')
                        .doc('TSL2561')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      }
                      // อ่านค่า LightSystem_State จาก Firestore
                      var data13 = snapshot.data!;
                      int L_state =
                          int.parse(data13['LightSystem_State'] ?? "0");
                      return Row(
                        children: [
                          Text(
                            'OFF',
                            style: TextStyle(color: Colors.white),
                          ),
                          Switch(
                            value: L_state == 1, // ถ้า 1 = ON, 0 = OFF
                            activeColor: const Color.fromARGB(255, 224, 153, 0),
                            onChanged: (value) {
                              // เมื่อเปลี่ยนค่าให้ส่งข้อมูลไปยัง MQTT
                              if (value) {
                                // ส่ง 'L_ON' เมื่อเปลี่ยนเป็น ON
                                _mqttManager.sendMessage('L_ON');
                                _firestore
                                    .collection('Sensors')
                                    .doc('TSL2561')
                                    .update({
                                  'LightSystem_State': "1",
                                  'Light_Manual_Mode': "1"
                                });
                              } else {
                                // ส่ง 'L_OFF' เมื่อเปลี่ยนเป็น OFF
                                _mqttManager.sendMessage('L_OFF');
                                _firestore
                                    .collection('Sensors')
                                    .doc('TSL2561')
                                    .update({
                                  'LightSystem_State': "0",
                                  'Light_Manual_Mode': "1",
                                });
                              }
                            },
                          ),
                          Text(
                            'ON',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reset Time',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // เรียก Pop-up
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('ยืนยันการ Reset'),
                                content: Text(
                                    'ต้องการ reset ระบบไฟ ไปที่ ON [0.00] / OFF [6.00] หรือไม่?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); // ปิด Pop-up
                                    },
                                    child: Text('ไม่'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // ส่งข้อความ MQTT
                                      _mqttManager.sendMessage('resetTime');
                                      Navigator.of(context).pop(); // ปิด Pop-up
                                    },
                                    child: Text('ใช่'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red, // สีพื้นหลังปุ่ม
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4), // ขอบมน
                          ),
                          minimumSize: Size(
                              60, 20), // กำหนดขนาดขั้นต่ำของปุ่ม (กว้าง, สูง)
                          padding: EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4), // ลด Padding
                        ),
                        child: Text(
                          'Reset',
                          style: TextStyle(
                            color: Colors.white, // สีตัวหนังสือ
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ใส่เวลา เปิด ที่ต้องการ',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10), // ระยะห่างระหว่างบรรทัด
              // TextBox และปุ่มส่งในบรรทัดเดียวกัน
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _lightController, // ใช้ Controller
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white24, // สีพื้นหลัง TextBox
                        hintText: "กรอก เวลา เช่น 0.00 ...",
                        hintStyle: TextStyle(color: Colors.white54),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      keyboardType: TextInputType.number, // ประเภทข้อมูลตัวเลข
                    ),
                  ),
                  SizedBox(width: 10), // ระยะห่างระหว่าง TextField กับปุ่ม
                  ElevatedButton(
                    onPressed: () {
                      String L_set = _lightController.text.trim();
                      // ตรวจสอบรูปแบบ เช่น ON=hh.mm
                      RegExp timeFormat = RegExp(r'(\d{1,2})\.(\d{1,2})$');
                      if (L_set.isNotEmpty && timeFormat.hasMatch(L_set)) {
                        // แยกชั่วโมงและนาทีออกจากข้อความ
                        final match = timeFormat.firstMatch(L_set);
                        int? hour =
                            int.tryParse(match?.group(1) ?? ""); // ชั่วโมง
                        int? minute =
                            int.tryParse(match?.group(2) ?? ""); // นาที

                        if (hour != null &&
                            minute != null &&
                            hour < 24 &&
                            minute < 60) {
                          // ถ้าค่าชั่วโมงและนาทีอยู่ในขอบเขตที่ถูกต้อง
                          _mqttManager.sendMessage('ON=$L_set');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("เวลาที่เปิดตั้งไว้ : $L_set"),
                              backgroundColor: Colors.green,
                            ),
                          );
                          _lightController.clear(); // ล้างค่าใน TextField
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text("กรุณากรอกเวลาในช่วง 00.00 ถึง 23.59"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                "กรุณากรอกเวลาในรูปแบบที่ถูกต้อง เช่น ON=12.30"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent, // สีปุ่ม
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    child: Text(
                      'ส่ง',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ใส่เวลา ปิด ที่ต้องการ',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10), // ระยะห่างระหว่างบรรทัด
              // TextBox และปุ่มส่งในบรรทัดเดียวกัน
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _lightController, // ใช้ Controller
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white24, // สีพื้นหลัง TextBox
                        hintText: "กรอก เวลา เช่น 0.00 ...",
                        hintStyle: TextStyle(color: Colors.white54),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      keyboardType: TextInputType.number, // ประเภทข้อมูลตัวเลข
                    ),
                  ),
                  SizedBox(width: 10), // ระยะห่างระหว่าง TextField กับปุ่ม
                  ElevatedButton(
                    onPressed: () {
                      String L_limit = _lightController1.text.trim();
                      // ตรวจสอบรูปแบบ เช่น ON=hh.mm
                      RegExp timeFormat = RegExp(r'(\d{1,2})\.(\d{1,2})$');
                      if (L_limit.isNotEmpty && timeFormat.hasMatch(L_limit)) {
                        // แยกชั่วโมงและนาทีออกจากข้อความ
                        final match = timeFormat.firstMatch(L_limit);
                        int? hour =
                            int.tryParse(match?.group(1) ?? ""); // ชั่วโมง
                        int? minute =
                            int.tryParse(match?.group(2) ?? ""); // นาที

                        if (hour != null &&
                            minute != null &&
                            hour < 24 &&
                            minute < 60) {
                          // ถ้าค่าชั่วโมงและนาทีอยู่ในขอบเขตที่ถูกต้อง
                          _mqttManager.sendMessage('OFF=$L_limit');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("เวลาที่เปิดตั้งไว้ : $L_limit"),
                              backgroundColor: Colors.green,
                            ),
                          );
                          _lightController.clear(); // ล้างค่าใน TextField
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text("กรุณากรอกเวลาในช่วง 00.00 ถึง 23.59"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                "กรุณากรอกเวลาในรูปแบบที่ถูกต้อง เช่น ON=12.30"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent, // สีปุ่ม
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    child: Text(
                      'ส่ง',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          )),

      //Navbar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
        height: 60,
        margin: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(18)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.home, color: Colors.redAccent),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WelcomePage(),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.thermostat,
                  color: const Color.fromARGB(255, 167, 3, 218)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DHT_page(),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.lightbulb,
                  color: const Color.fromARGB(255, 252, 181, 88)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TSL2561_page(),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.shower,
                  color: const Color.fromARGB(255, 0, 79, 248)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VL53L0X_page(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
