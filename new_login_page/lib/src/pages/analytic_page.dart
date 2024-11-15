import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

// Define the SubjectScore class to store subject names and their scores over the years for each class
class SubjectScore {
  final String subject;
  final List<int> scores; // The percentage scores for each year

  SubjectScore(this.subject, this.scores);
}

// Class data for different years (8th, 9th, 10th)
Map<String, List<SubjectScore>> classData = {
  '8th': [
    SubjectScore("Maths", [75, 80, 90, 85, 88, 92]),
    SubjectScore("Physics", [70, 75, 78, 80, 85, 90]),
    SubjectScore("Social Science", [65, 68, 72, 75, 80, 85]),
    SubjectScore("Biology", [60, 62, 65, 70, 72, 80]),
    SubjectScore("Chemistry", [70, 72, 75, 78, 80, 85]),
  ],
  '9th': [
    SubjectScore("Maths", [80, 85, 90, 88, 92, 95]),
    SubjectScore("Physics", [75, 78, 82, 85, 88, 92]),
    SubjectScore("Social Science", [70, 72, 75, 80, 85, 88]),
    SubjectScore("Biology", [65, 70, 75, 80, 85, 90]),
    SubjectScore("Chemistry", [80, 82, 85, 87, 90, 92]),
  ],
  '10th': [
    SubjectScore("Maths", [85, 88, 90, 92, 94, 96]),
    SubjectScore("Physics", [80, 82, 85, 88, 90, 92]),
    SubjectScore("Social Science", [75, 78, 80, 82, 85, 90]),
    SubjectScore("Biology", [70, 75, 78, 80, 85, 90]),
    SubjectScore("Chemistry", [80, 85, 88, 90, 92, 95]),
  ],
};

void main() {
  runApp(MaterialApp(home: AnalyticsChart()));
}

class AnalyticsChart extends StatefulWidget {
  @override
  _AnalyticsChartState createState() => _AnalyticsChartState();
}

class _AnalyticsChartState extends State<AnalyticsChart> {
  String selectedClass = '8th'; // Default class

  // Function to build line data for the selected class
  List<LineChartBarData> _buildLineBarsData(List<SubjectScore> subjectScores) {
    List<LineChartBarData> lineBars = [];
    for (var subjectScore in subjectScores) {
      lineBars.add(LineChartBarData(
        spots: _getChartDataPoints(subjectScore.scores),
        isCurved: true,
        color: Colors.blue, // Change color based on the subject
        belowBarData: BarAreaData(show: true),
        barWidth: 4,
      ));
    }
    return lineBars;
  }

  // Function to convert scores to chart data points (FlSpot)
  List<FlSpot> _getChartDataPoints(List<int> scores) {
    List<FlSpot> spots = [];
    for (int i = 0; i < scores.length; i++) {
      spots.add(FlSpot(i.toDouble(), scores[i].toDouble()));
    }
    return spots;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Class Analytics")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Class selection buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: ['8th', '9th', '10th'].map((className) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedClass = className;
                      });
                    },
                    child: Text(className),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedClass == className ? Colors.blue : Colors.grey, // Use backgroundColor instead of primary
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            // Line chart for selected class
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          const years = ["2019", "2020", "2021", "2022", "2023", "2024"];
                          return Text(years[value.toInt()]);
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  minX: 0,
                  maxX: 5, // 6 years (2019-2024)
                  minY: 0,
                  maxY: 100, // Percentage-based scores (0-100%)
                  lineBarsData: _buildLineBarsData(classData[selectedClass]!),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
