import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/beer_record.dart';
import '../theme/app_theme.dart';

class HourlyChart extends StatelessWidget {
  final List<BeerRecord> beers;

  const HourlyChart({super.key, required this.beers});

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

    List<BarChartGroupData> barGroups = [];
    hourlyData.forEach((hour, volume) {
      barGroups.add(
        BarChartGroupData(
          x: hour,
          barRods: [
            BarChartRodData(
              toY: volume.toDouble(),
              color: AppTheme.amber,
              width: 16,
              borderRadius: BorderRadius.circular(2),
              borderSide: const BorderSide(color: AppTheme.brownMid, width: 1),
            ),
          ],
        ),
      );
    });

    return BarChart(
      BarChartData(
        barGroups: barGroups,
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
