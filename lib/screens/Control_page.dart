import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../mqtt_manager.dart'; // เชื่อมต่อ MQTT
import './welcome_page.dart';
import './DHT_page.dart';
import './VL53L0X_page.dart';
import './TSL2561_page.dart';
import '../constants.dart';

class control_page extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final MQTTManager _mqttManager = MQTTManager();

  // ประกาศ Controller สำหรับ TextField
  final TextEditingController _tempController = TextEditingController();
  final TextEditingController _tempController1 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40), //Cooler system
            Text(
              'Cooler System Control',
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
                      _firestore.collection('Sensors').doc('DHT11').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }
                    String humidity = snapshot.data!['Humidity'];
                    String temperature = snapshot.data!['Temperature'];
                    String t_set = snapshot.data!['Temperature_Set'];
                    String t_limit = snapshot.data!['Temperature_Limit'];

                    return Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // จัดข้อความชิดซ้าย
                      children: [
                        SizedBox(height: 5),
                        Text(
                          'ค่า Tempurature : $temperature °C',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'ค่า Humidity : $humidity %',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'ค่า Tempurature Set : $t_set °C',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'ค่า Tempurature Limit : $t_limit °C',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
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
                      _firestore.collection('Sensors').doc('DHT11').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }
                    // อ่านค่า CoolerSystem_Mode จาก Firestore
                    var data = snapshot.data!;
                    int mode = int.parse(data['CoolerSystem_Mode'] ?? "0");
                    return Row(
                      children: [
                        Text(
                          'AUTO',
                          style: TextStyle(color: Colors.white),
                        ),
                        Switch(
                          value: mode == 1, // ถ้า 1 = Manual, 0 = Auto
                          inactiveThumbColor:
                              const Color.fromARGB(255, 132, 0, 209),
                          onChanged: null,
                        ),
                        Text(
                          'MANUAL',
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
                      _firestore.collection('Sensors').doc('DHT11').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }
                    // อ่านค่า CoolerSystem_stete จาก Firestore
                    var data1 = snapshot.data!;
                    int state = int.parse(data1['CoolerSystem_State'] ?? "0");
                    return Row(
                      children: [
                        Text(
                          'OFF',
                          style: TextStyle(color: Colors.white),
                        ),
                        Switch(
                            value: state == 1, // ถ้า 1 = ON, 0 = OFF
                            inactiveThumbColor:
                                const Color.fromARGB(255, 132, 0, 209),
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
                      _firestore.collection('Sensors').doc('DHT11').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }
                    // อ่านค่า CoolerSystem_Mode จาก Firestore
                    var data2 = snapshot.data!;
                    int mode = int.parse(data2['CoolerSystem_Mode'] ?? "0");
                    return Row(
                      children: [
                        Text(
                          'AUTO',
                          style: TextStyle(color: Colors.white),
                        ),
                        Switch(
                          value: mode == 1, // ถ้า 1 = Manual, 0 = Auto
                          activeColor: const Color.fromARGB(255, 183, 0, 255),
                          onChanged: (value) {
                            // เมื่อเปลี่ยนค่าให้ส่งข้อมูลไปยัง MQTT
                            if (value) {
                              // ส่ง 'C_OFF' เมื่อเปลี่ยนเป็น Manual
                              _mqttManager.sendMessage('C_OFF');
                              _firestore
                                  .collection('Sensors')
                                  .doc('DHT11')
                                  .update({
                                'CoolerSystem_Mode': "1",
                              });
                            } else {
                              // ส่ง 'C_AUTO' เมื่อเปลี่ยนเป็น Auto
                              _mqttManager.sendMessage('C_AUTO');
                              _firestore
                                  .collection('Sensors')
                                  .doc('DHT11')
                                  .update({
                                'CoolerSystem_Mode': "0",
                              });
                            }
                          },
                        ),
                        Text(
                          'MANUAL',
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
                      _firestore.collection('Sensors').doc('DHT11').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }
                    // อ่านค่า CoolerSystem_stete จาก Firestore
                    var data3 = snapshot.data!;
                    int state = int.parse(data3['CoolerSystem_State'] ?? "0");
                    return Row(
                      children: [
                        Text(
                          'OFF',
                          style: TextStyle(color: Colors.white),
                        ),
                        Switch(
                          value: state == 1, // ถ้า 1 = ON, 0 = OFF
                          activeColor: const Color.fromARGB(255, 132, 0, 209),
                          onChanged: (value) {
                            // เมื่อเปลี่ยนค่าให้ส่งข้อมูลไปยัง MQTT
                            if (value) {
                              // ส่ง 'C_ON' เมื่อเปลี่ยนเป็น ON
                              _mqttManager.sendMessage('C_ON');
                              _firestore
                                  .collection('Sensors')
                                  .doc('DHT11')
                                  .update({
                                'CoolerSystem_Mode': "1",
                                'CoolerSystem_State': "1"
                              });
                            } else {
                              // ส่ง 'C_OFF' เมื่อเปลี่ยนเป็น OFF
                              _mqttManager.sendMessage('C_OFF');
                              _firestore
                                  .collection('Sensors')
                                  .doc('DHT11')
                                  .update({
                                'CoolerSystem_Mode': "1",
                                'CoolerSystem_State': "0"
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
                      'Reset Temperature',
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
                                  'ต้องการ reset อุณหภูมิ เครื่องทำความเย็นทำงาน ไปที่ 34 หรือไม่?'),
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
                                    _mqttManager.sendMessage('reset_T');
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
                      'ใส่ค่า Temperature ที่ต้องการ',
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
                    controller: _tempController, // ใช้ Controller
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white24, // สีพื้นหลัง TextBox
                      hintText: "กรอกค่า Temperature...",
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
                    String t_set = _tempController.text.trim();
                    if (t_set.isNotEmpty) {
                      // ตรวจสอบว่าค่าเป็นตัวเลขและไม่เกิน 40
                      int? temperature = int.tryParse(t_set);
                      if (temperature != null && temperature <= 40) {
                        // ส่งข้อความผ่าน MQTT
                        _mqttManager.sendMessage('T_set:$t_set');
                        // แสดงข้อความเสร็จสิ้น
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Temperature set to: $t_set"),
                            backgroundColor: Colors.green,
                          ),
                        );
                        // ล้างค่าใน TextField
                        _tempController.clear();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text("กรุณาใส่ค่า Temperature ที่ไม่เกิน 40"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("กรุณาใส่ค่า Temperature"),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ใส่ค่า Temperature Limit ที่ต้องการ',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _tempController1, // ใช้ Controller
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white24, // สีพื้นหลัง TextBox
                      hintText: "กรอกค่า Temperature Limit...",
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
                    String t_limit = _tempController1.text.trim();
                    String t_set = _tempController.text
                        .trim(); // ดึงค่าจาก Temperature Controller
                    int? tempSet =
                        int.tryParse(t_set); // แปลงค่า Temperature เป็นตัวเลข
                    int? tempLimit = int.tryParse(
                        t_limit); // แปลงค่า Temperature Limit เป็นตัวเลข

                    if (t_limit.isNotEmpty && tempLimit != null) {
                      if (tempLimit >= 25 && tempLimit != tempSet) {
                        // ส่งข้อความผ่าน MQTT
                        _mqttManager.sendMessage('T_limit:$t_limit');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Temperature Limit set to: $t_limit"),
                            backgroundColor: Colors.green,
                          ),
                        );
                        // ล้างค่าใน TextField
                        _tempController1.clear();
                      } else if (tempLimit < 25) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text("Temperature Limit ต้องไม่น้อยกว่า 25"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } else if (tempLimit == tempSet) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                "Temperature Limit ต้องไม่เท่ากับค่า Temperature"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text("กรุณาใส่ค่า Temperature Limit ที่ถูกต้อง"),
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
          ],
        ),
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
