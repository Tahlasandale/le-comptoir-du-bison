import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/beer_record.dart';
import '../theme/app_theme.dart';

class CumulativeChart extends StatelessWidget {
  final List<BeerRecord> beers;

  const CumulativeChart({super.key, required this.beers});

  @override
  Widget build(BuildContext context) {
    Map<int, int> hourlyData = {};
    int nowHour = DateTime.now().hour;
    int startHour = nowHour - 5;
    if (beers.isNotEmpty) {
      int firstHour = DateTime.fromMillisecondsSinceEpoch(beers.first.timestamp).hour;
      startHour = firstHour < startHour ? firstHour : startHour;
    }
    startHour = startHour < 0 ? 0 : startHour;

    for (int i = startHour; i <= nowHour; i++) {
      hourlyData[i] = 0;
    }

    for (var beer in beers) {
      int h = DateTime.fromMillisecondsSinceEpoch(beer.timestamp).hour;
      if (h >= startHour) {
        hourlyData[h] = (hourlyData[h] ?? 0) + beer.volume;
      }
    }

    List<FlSpot> spots = [];
    int cumulative = 0;
    hourlyData.forEach((hour, volume) {
      cumulative += volume;
      spots.add(FlSpot(hour.toDouble(), cumulative.toDouble()));
    });

    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: AppTheme.amber,
            barWidth: 2.5,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: AppTheme.amber.withOpacity(0.12),
            ),
          ),
        ],
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => FlLine(
            color: AppTheme.brownMid.withOpacity(0.15),
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) => Text(
                '${value.toInt()}h',
                style: AppTheme.theme.textTheme.labelSmall,
              ),
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(
          show: true,
          border: const Border(
            bottom: BorderSide(color: AppTheme.brownMid, width: 1),
            left: BorderSide(color: AppTheme.brownMid, width: 1),
          ),
        ),
      ),
    );
  }
}
