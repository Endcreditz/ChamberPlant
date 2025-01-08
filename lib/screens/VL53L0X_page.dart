import 'package:chamberplant/constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import './welcome_page.dart';
import './TSL2561_page.dart';
import './DHT_page.dart';
import './screen.dart';
import './Control_page2.dart';

class MyApp3 extends StatelessWidget {
  const MyApp3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: VL53L0X_page(),
    );
  }
}

class VL53L0X_page extends StatefulWidget {
  @override
  _VL53L0X_pageState createState() => _VL53L0X_pageState();
}

class _VL53L0X_pageState extends State<VL53L0X_page> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<FlSpot> spots = [];
  List<FlSpot> spots1 = [];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    listenToWaterHeight();
  }

  void listenToWaterHeight() {
    firestore
        .collection('Sensors')
        .doc('VL53L0X')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        String WaterHeight = snapshot.data()?['Dif_Distance;'] ?? '0';
        double WaterHeightValue = double.tryParse(WaterHeight) ?? 0.0;

        String Volume = snapshot.data()?['Water_Volume;'] ?? '0';
        double VolumeValue = double.tryParse(Volume) ?? 0.0;

        setState(() {
          // เพิ่มจุดใหม่ในกราฟ
          spots.add(FlSpot(currentIndex.toDouble(), WaterHeightValue));
          currentIndex++;

          spots1.add(FlSpot(currentIndex.toDouble(), VolumeValue));
          currentIndex++;

          // จำกัดจำนวนจุดในกราฟ (แสดงจุดล่าสุด 60 จุด)
          if (spots.length > 60) {
            spots.removeAt(60);
          }

          // จำกัดจำนวนจุดในกราฟ (แสดงจุดล่าสุด 60 จุด)
          if (spots1.length > 60) {
            spots.removeAt(60);
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
                    'VL53L0X',
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
                          builder: (context) => control_page2(),
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
                  stream: firestore
                      .collection('Sensors')
                      .doc('VL53L0X')
                      .snapshots(),
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
                    String W_set = snapshot.data!['WaterLevel_Set'];
                    String avg_D = snapshot.data!['Sum_DistanceCM'];
                    String diff_D = snapshot.data!['Dif_Distance'];
                    String w_lv = snapshot.data!['Water_Level'];
                    String w_vol = snapshot.data!['Water_Volume'];
                    String mode = snapshot.data!['Water_Manual_Mode'] == "0"
                        ? "Auto"
                        : "Manual";
                    String state = snapshot.data!['WaterSystem_State'] == "0"
                        ? "OFF"
                        : "ON";

                    return ListView(
                      children: [
                        LineChart10(
                          icon: Icons.water,
                          title: 'Water Height',
                          value: spots.isNotEmpty
                              ? '${spots.last.y.toStringAsFixed(2)} cm'
                              : '0 cm',
                          graphColor: Colors.blue,
                          data: spots,
                        ),
                        SizedBox(height: 20),
                        LineChart11(
                          icon: Icons.auto_graph,
                          title: 'Water Volume',
                          value: spots.isNotEmpty
                              ? '${spots1.last.y.toStringAsFixed(2)} cm³'
                              : '0 cm³',
                          graphColor: const Color.fromARGB(255, 0, 38, 255),
                          data: spots1,
                        ),
                        SizedBox(height: 20),
                        // สร้างปุ่ม ON/OFF
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Water System',
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
                        SizedBox(height: 10),
                        // แสดงสถานะการทำงาน
                        Text(
                          'ความสูงของน้ำที่ต้องการ : $W_set cm',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        // แสดงสถานะการทำงาน
                        Text(
                          'ความสูงของน้ำ : $diff_D cm',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        // แสดงสถานะการทำงาน
                        Text(
                          'ปริมาณน้ำในถาด : $w_vol cm³',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        // แสดงสถานะการทำงาน
                        Text(
                          'ช่วงความสูงของน้ำ : $w_lv cm',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        // แสดงสถานะการทำงาน
                        Text(
                          'ความสูงห่างจากตัว sensor : $avg_D cm',
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
            ],
          ),
        ));
  }
}

class LineChart10 extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color graphColor;
  final List<FlSpot> data;

  const LineChart10({
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
            height: 150,
            child: LineChart(
              LineChartData(
                  minY: 0,
                  maxY: 3,
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
                          interval: 1, // ตั้งค่า step ของแกน Y
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toStringAsFixed(
                                  0), // แสดงค่าในรูปแบบ 1 ตำแหน่งทศนิยม
                              style: TextStyle(
                                  color:
                                      Colors.white), // กำหนดสีตัวอักษรเป็นสีขาว
                            );
                          },
                        ),
                        axisNameWidget: Text(
                          'Water Height (CM)',
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

class LineChart11 extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color graphColor;
  final List<FlSpot> data;

  const LineChart11({
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
            height: 500,
            child: LineChart(
              LineChartData(
                  minY: 0,
                  maxY: 1600,
                  minX: -0.5, // ค่า X ต่ำสุด
                  maxX: 60, // ค่า X สูงสุด
                  lineBarsData: [
                    LineChartBarData(
                      spots: data,
                      color: Color.fromARGB(255, 0, 38, 255),
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
                          interval: 200, // ตั้งค่า step ของแกน Y
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toStringAsFixed(
                                  0), // แสดงค่าในรูปแบบ 1 ตำแหน่งทศนิยม
                              style: TextStyle(
                                  fontSize: 8,
                                  color:
                                      Colors.white), // กำหนดสีตัวอักษรเป็นสีขาว
                            );
                          },
                        ),
                        axisNameWidget: Text(
                          'Volume (cm³)',
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
