import 'package:chamberplant/constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import './welcome_page.dart';
import './TSL2561_page.dart';
import './VL53L0X_page.dart';
import './Control_page.dart';
import './screen.dart';

class MyApp1 extends StatelessWidget {
  const MyApp1({Key? key}) : super(key: key);

  @override

  /// Builds the DHT page.
  ///
  /// This is a stateless widget that wraps the [DHT_page] widget with a

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DHT_page(),
    );
  }
}

class DHT_page extends StatefulWidget {
  @override
  _DHT_pageState createState() => _DHT_pageState();
}

class _DHT_pageState extends State<DHT_page> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<FlSpot> spots = [];
  List<FlSpot> spots1 = [];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    listenToDHT();
  }

  void listenToDHT() {
    firestore.collection('Sensors').doc('DHT11').snapshots().listen((snapshot) {
      if (snapshot.exists) {
        String t = snapshot.data()?['Temperature'] ?? '0';
        double T_Value = double.tryParse(t) ?? 0.0;

        String h = snapshot.data()?['Humidity'] ?? '0';
        double H_Value = double.tryParse(h) ?? 0.0;

        setState(() {
          // เพิ่มจุดใหม่ในกราฟ
          spots.add(FlSpot(currentIndex.toDouble(), T_Value));
          currentIndex++;

          spots1.add(FlSpot(currentIndex.toDouble(), H_Value));
          currentIndex++;

          // จำกัดจำนวนจุดในกราฟ (แสดงจุดล่าสุด 60 จุด)
          if (spots.length > 60) {
            spots.removeAt(60);
          }

          // จำกัดจำนวนจุดในกราฟ (แสดงจุดล่าสุด 60 จุด)
          if (spots1.length > 60) {
            spots1.removeAt(60);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kBackgroundColor,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Text(
                'Sensors',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, // จัดตำแหน่งระหว่างข้อความกับปุ่ม
                children: [
                  Text(
                    'DHT_11',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 20,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => control_page(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(
                          255, 252, 252, 252), // สีพื้นหลังปุ่ม
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4), // ขอบมน
                      ),
                      minimumSize:
                          Size(60, 20), // กำหนดขนาดขั้นต่ำของปุ่ม (กว้าง, สูง)
                      padding: EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4), // ลด Padding
                    ),
                    child: Text(
                      'Control Page',
                      style: TextStyle(
                        color: const Color.fromARGB(
                            255, 14, 13, 13), // สีตัวหนังสือ
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2),
              Expanded(
                child: StreamBuilder<DocumentSnapshot>(
                  stream:
                      firestore.collection('Sensors').doc('DHT11').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return Center(child: Text('No Data Found'));
                    }

                    // ดึงข้อมูล
                    String humidity = snapshot.data!['Humidity'];
                    String temperature = snapshot.data!['Temperature'];
                    String mode = snapshot.data!['CoolerSystem_Mode'] == "0"
                        ? "Auto"
                        : "Manual";
                    String state = snapshot.data!['CoolerSystem_State'] == "0"
                        ? "OFF"
                        : "ON";

                    return ListView(
                      children: [
                        LineChart20(
                            icon: Icons.water_drop,
                            title: 'Humidity',
                            value: spots1.isNotEmpty
                                ? '${spots1.last.y.toStringAsFixed(2)} %'
                                : '0 %',
                            graphColor: Colors.blue,
                            data: spots1),
                        SizedBox(height: 20),
                        LineChart21(
                            icon: Icons.thermostat,
                            title: 'Temperature',
                            value: spots.isNotEmpty
                                ? '${spots.last.y.toStringAsFixed(2)} °C'
                                : '0 °C',
                            graphColor: Colors.red,
                            data: spots),
                        SizedBox(height: 20),
                        // สร้างปุ่ม ON/OFF
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Cooler System',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        // แสดงโหมดระบบการทำงาน
                        Text(
                          'ค่า Tempurature : $temperature °C',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        // แสดงโหมดระบบการทำงาน
                        Text(
                          'ค่า Humidity : $humidity %',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        // แสดงโหมดระบบการทำงาน
                        Text(
                          'โหมดการทำงาน : $mode',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        // แสดงสถานะการทำงาน
                        Text(
                          'สถานะการทำงาน : $state',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  },
                ),
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
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
              bottomLeft: Radius.circular(18),
              bottomRight: Radius.circular(18),
            ),
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
              // Added new settings icon
            ],
          ),
        ));
  }
}

class LineChart20 extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color graphColor;
  final List<FlSpot> data;

  const LineChart20({
    required this.icon,
    required this.title,
    required this.value,
    required this.graphColor,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: graphColor,
                size: 30,
              ),
              SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 300,
            child: LineChart(
              LineChartData(
                  minY: 0,
                  maxY: 100,
                  minX: -0.5, // ค่า X ต่ำสุด
                  maxX: 60, // ค่า X สูงสุด
                  lineBarsData: [
                    LineChartBarData(
                      spots: data,
                      color: Colors.blue,
                      barWidth: 3,
                      isCurved: true,
                      dotData:
                          FlDotData(show: false), // ซ่อนจุดเพื่อลดความซับซ้อน
                    ),
                  ],
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(),
                    ),
                    leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 20, // ตั้งค่า step ของแกน Y
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toStringAsFixed(
                                  0), // แสดงค่าในรูปแบบ 1 ตำแหน่งทศนิยม
                              style: TextStyle(
                                  fontSize: 10,
                                  color:
                                      Colors.white), // กำหนดสีตัวอักษรเป็นสีขาว
                            );
                          },
                        ),
                        axisNameWidget: Text(
                          'Humidity (%)',
                          style: TextStyle(color: Colors.white),
                        )),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(
                      show: true,
                      drawVerticalLine: true,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.grey[800],
                        );
                      })),
            ),
          )
        ],
      ),
    );
  }
}

class LineChart21 extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color graphColor;
  final List<FlSpot> data;

  const LineChart21({
    required this.icon,
    required this.title,
    required this.value,
    required this.graphColor,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: graphColor,
                size: 30,
              ),
              SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 300,
            child: LineChart(
              LineChartData(
                  minY: 0,
                  maxY: 40,
                  minX: -0.5, // ค่า X ต่ำสุด
                  maxX: 60, // ค่า X สูงสุด
                  lineBarsData: [
                    LineChartBarData(
                      spots: data,
                      color: Colors.red,
                      barWidth: 3,
                      isCurved: true,
                      dotData:
                          FlDotData(show: false), // ซ่อนจุดเพื่อลดความซับซ้อน
                    ),
                  ],
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(),
                    ),
                    leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 10, // ตั้งค่า step ของแกน Y
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toStringAsFixed(
                                  0), // แสดงค่าในรูปแบบ 1 ตำแหน่งทศนิยม
                              style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      Colors.white), // กำหนดสีตัวอักษรเป็นสีขาว
                            );
                          },
                        ),
                        axisNameWidget: Text(
                          'Temperature (°C)',
                          style: TextStyle(color: Colors.white),
                        )),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(
                      show: true,
                      drawVerticalLine: true,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.grey[800],
                        );
                      })),
            ),
          )
        ],
      ),
    );
  }
}
