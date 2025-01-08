import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class MyApp2 extends StatelessWidget {
  const MyApp2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TSL2561_page(),
    );
  }
}

class TSL2561_page extends StatefulWidget {
  @override
  _TSL2561_pageState createState() => _TSL2561_pageState();
}

class _TSL2561_pageState extends State<TSL2561_page> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<FlSpot> spots = [];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    listenToLightIntensity();
  }

  void listenToLightIntensity() {
    firestore
        .collection('Sensors')
        .doc('TSL2561')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        String lightIntensity = snapshot.data()?['Light_Intensity'] ?? '0';
        double intensityValue = double.tryParse(lightIntensity) ?? 0.0;

        setState(() {
          // เพิ่มจุดใหม่ในกราฟ
          spots.add(FlSpot(currentIndex.toDouble(), intensityValue));
          currentIndex++;

          // จำกัดจำนวนจุดในกราฟ (แสดงจุดล่าสุด 50 จุด)
          if (spots.length > 50) {
            spots.removeAt(0);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  LineChart1(
                    icon: Icons.lightbulb,
                    title: 'Light Intensity',
                    value: spots.isNotEmpty
                        ? '${spots.last.y.toStringAsFixed(2)} LUX'
                        : '0 LUX',
                    graphColor: Color.fromARGB(255, 252, 181, 88),
                    data: spots,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LineChart1 extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color graphColor;
  final List<FlSpot> data;

  const LineChart1({
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
                minX: 0,
                maxX: 50,
                lineBarsData: [
                  LineChartBarData(
                    spots: data,
                    color: graphColor,
                    barWidth: 3,
                    isCurved: true,
                  ),
                ],
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 10,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toStringAsFixed(0),
                          style: TextStyle(color: Colors.white),
                        );
                      },
                    ),
                    axisNameWidget: Text(
                      'Time (seconds)',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 20,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toStringAsFixed(0),
                          style: TextStyle(color: Colors.white),
                        );
                      },
                    ),
                    axisNameWidget: Text(
                      'Light Intensity (Lux)',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
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
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
