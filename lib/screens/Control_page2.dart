import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../mqtt_manager.dart'; // เชื่อมต่อ MQTT
import './welcome_page.dart';
import './DHT_page.dart';
import './VL53L0X_page.dart';
import './TSL2561_page.dart';
import '../constants.dart';

class control_page2 extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final MQTTManager _mqttManager = MQTTManager();

  final TextEditingController _waterController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          //ระบบ น้ำ
          SizedBox(height: 40), //Water system
          Text(
            'Water System Control',
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
                stream:
                    _firestore.collection('Sensors').doc('VL53L0X').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }

                  String W_set = snapshot.data!['WaterLevel_Set'];
                  String avg_D = snapshot.data!['Sum_DistanceCM'];
                  String diff_D = snapshot.data!['Dif_Distance'];
                  String w_lv = snapshot.data!['Water_Level'];
                  String w_vol = snapshot.data!['Water_Volume'];

                  return Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // จัดข้อความชิดซ้าย
                    children: [
                      SizedBox(height: 10),
                      Text(
                        'ความสูงของน้ำที่ต้องการ : $W_set cm',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'ความสูงของน้ำ : $diff_D cm',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      // แสดงสถานะการทำงาน
                      Text(
                        'ปริมาณน้ำในถาด : $w_vol cm³',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      // แสดงสถานะการทำงาน
                      Text(
                        'ช่วงค่าความสูงของน้ำ : $w_lv cm',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      // แสดงสถานะการทำงาน
                      Text(
                        'ความสูงห่างจากตัว sensor : $avg_D cm',
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
                stream:
                    _firestore.collection('Sensors').doc('VL53L0X').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  // อ่านค่า CoolerSystem_Mode จาก Firestore
                  var data10 = snapshot.data!;
                  int W_mode = int.parse(data10['Water_Manual_Mode'] ?? "0");
                  return Row(
                    children: [
                      Text(
                        'AUTO',
                        style: TextStyle(color: Colors.white),
                      ),
                      Switch(
                        value: W_mode == 1, // ถ้า 1 = Manual, 0 = Auto
                        inactiveThumbColor:
                            const Color.fromARGB(255, 0, 153, 255),
                        onChanged: null,
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
                stream:
                    _firestore.collection('Sensors').doc('VL53L0X').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  // อ่านค่า WaterSystem_State จาก Firestore
                  var data11 = snapshot.data!;
                  int W_state = int.parse(data11['WaterSystem_State'] ?? "0");
                  return Row(
                    children: [
                      Text(
                        'OFF',
                        style: TextStyle(color: Colors.white),
                      ),
                      Switch(
                          value: W_state == 1, // ถ้า 1 = ON, 0 = OFF
                          inactiveThumbColor:
                              const Color.fromARGB(255, 54, 80, 192),
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
                stream:
                    _firestore.collection('Sensors').doc('VL53L0X').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  // อ่านค่า CoolerSystem_Mode จาก Firestore
                  var data10 = snapshot.data!;
                  int W_mode = int.parse(data10['Water_Manual_Mode'] ?? "0");
                  return Row(
                    children: [
                      Text(
                        'AUTO',
                        style: TextStyle(color: Colors.white),
                      ),
                      Switch(
                        value: W_mode == 1, // ถ้า 1 = Manual, 0 = Auto
                        activeColor: const Color.fromARGB(255, 0, 153, 255),
                        onChanged: (value) {
                          // เมื่อเปลี่ยนค่าให้ส่งข้อมูลไปยัง MQTT
                          if (value) {
                            // ส่ง 'W_OFF' เมื่อเปลี่ยนเป็น Manual
                            _mqttManager.sendMessage('W_OFF');
                            _firestore
                                .collection('Sensors')
                                .doc('VL53L0X')
                                .update({
                              'Water_Manual_Mode': "1",
                            });
                          } else {
                            // ส่ง 'W_AUTO' เมื่อเปลี่ยนเป็น Auto
                            _mqttManager.sendMessage('W_AUTO');
                            _firestore
                                .collection('Sensors')
                                .doc('VL53L0X')
                                .update({
                              'Water_Manual_Mode': "0",
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
                stream:
                    _firestore.collection('Sensors').doc('VL53L0X').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  // อ่านค่า WaterSystem_State จาก Firestore
                  var data11 = snapshot.data!;
                  int W_state = int.parse(data11['WaterSystem_State'] ?? "0");
                  return Row(
                    children: [
                      Text(
                        'OFF',
                        style: TextStyle(color: Colors.white),
                      ),
                      Switch(
                        value: W_state == 1, // ถ้า 1 = ON, 0 = OFF
                        activeColor: const Color.fromARGB(255, 54, 80, 192),
                        onChanged: (value) {
                          // เมื่อเปลี่ยนค่าให้ส่งข้อมูลไปยัง MQTT
                          if (value) {
                            // ส่ง 'W_ON' เมื่อเปลี่ยนเป็น ON
                            _mqttManager.sendMessage('W_ON');
                            _firestore
                                .collection('Sensors')
                                .doc('VL53L0X')
                                .update({
                              'WaterSystem_State': "1",
                              'Water_Manual_Mode': "1"
                            });
                          } else {
                            // ส่ง 'W_OFF' เมื่อเปลี่ยนเป็น OFF
                            _mqttManager.sendMessage('W_OFF');
                            _firestore
                                .collection('Sensors')
                                .doc('VL53L0X')
                                .update({
                              'WaterSystem_State': "0",
                              'Water_Manual_Mode': "1"
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
                    'Reset ความสูงของน้ำที่ต้องการ',
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
                                'ต้องการ reset ความสูงของน้ำ [ความสูง = 0] หรือไม่?'),
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
                                  _mqttManager.sendMessage('reset_W');
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
                      minimumSize:
                          Size(60, 20), // กำหนดขนาดขั้นต่ำของปุ่ม (กว้าง, สูง)
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
                    'เปลี่ยน ความสูงของน้ำที่ต้องการ',
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
                  controller: _waterController, // ใช้ Controller
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white24, // สีพื้นหลัง TextBox
                    hintText:
                        "กรอกค่าความสูง [0.5 , 1 , 1.5 ,2] เท่านั่น...", //ถ้ากรอกค่าอื่น ระบบจะไม่หยุดน้ำ แม้จะอยู่ในโหมด AUTO
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
                  String w_set = _waterController.text.trim();
                  // รายการค่าที่อนุญาต
                  final allowedValues = {'0.5', '1', '1.5', '2'};

                  if (w_set.isNotEmpty && allowedValues.contains(w_set)) {
                    // ส่งข้อความผ่าน MQTT
                    _mqttManager.sendMessage('W_set:$w_set');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("ค่าความสูงของน้ำ ที่ต้องการ : $w_set"),
                        backgroundColor: Colors.green,
                      ),
                    );
                    // ล้างค่าใน TextField
                    _waterController.clear();
                  } else {
                    // แสดงข้อความข้อผิดพลาด
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            "กรอกค่าความสูงได้เฉพาะ [0.5, 1, 1.5, 2] เท่านั้น"),
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
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                child: Text(
                  'ส่ง',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ]),
      ),
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
