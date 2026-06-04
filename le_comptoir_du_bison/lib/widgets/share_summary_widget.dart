import 'package:flutter/material.dart';
import '../models/beer_record.dart';
import '../theme/app_theme.dart';
import 'cumulative_chart.dart';
import 'hourly_chart.dart';

class ShareSummaryWidget extends StatelessWidget {
  final List<BeerRecord> beers;
  final int totalVolume;
  final int sessionCount;
  final String peakHour;
  final double avgGlassSize;

  const ShareSummaryWidget({
    super.key,
    required this.beers,
    required this.totalVolume,
    required this.sessionCount,
    required this.peakHour,
    required this.avgGlassSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppTheme.cream,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Text(
            'Rapport d\'Hydratation',
            style: AppTheme.theme.textTheme.labelSmall?.copyWith(color: AppTheme.brownMid, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            'Le Comptoir du Bison',
            style: AppTheme.theme.textTheme.displayLarge?.copyWith(fontSize: 28),
          ),
          const SizedBox(height: 16),
          const Divider(color: AppTheme.brownMid, thickness: 2),
          const SizedBox(height: 16),

          // Stats Grid
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStat('Volume', '$totalVolume cl'),
              _buildStat('Tournées', '$sessionCount'),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStat('Pointe', peakHour),
              _buildStat('Format', '${avgGlassSize.round()}cl'),
            ],
          ),
          const SizedBox(height: 24),

          // Charts
          const Text('CONSO PAR HEURE', style: TextStyle(fontFamily: 'Special Elite', fontSize: 10)),
          const SizedBox(height: 8),
          SizedBox(height: 150, child: HourlyChart(beers: beers)),
          const SizedBox(height: 24),
          const Text('CUMULATIVE', style: TextStyle(fontFamily: 'Special Elite', fontSize: 10)),
          const SizedBox(height: 8),
          SizedBox(height: 150, child: CumulativeChart(beers: beers)),
          
          const SizedBox(height: 24),
          const Divider(color: AppTheme.brownMid),
          const SizedBox(height: 8),
          Text(
            'Brasserie Artisanale du Bison — Depuis 1847',
            style: AppTheme.theme.textTheme.labelSmall?.copyWith(fontSize: 8, color: AppTheme.brownMid),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(label.toUpperCase(), style: const TextStyle(fontFamily: 'Special Elite', fontSize: 8, color: AppTheme.brownLight)),
        Text(value, style: AppTheme.theme.textTheme.displayMedium?.copyWith(fontSize: 20)),
      ],
    );
  }
}
