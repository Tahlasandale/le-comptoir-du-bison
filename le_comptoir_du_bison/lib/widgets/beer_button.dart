import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class BeerButton extends StatelessWidget {
  final int volume;
  final String label;
  final Widget icon;
  final VoidCallback onTap;

  const BeerButton({
    super.key,
    required this.volume,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.parchment,
          border: Border.all(color: AppTheme.brownMid, width: 2),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.aged, width: 1),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 40, child: icon),
                const SizedBox(height: 4),
                Text(
                  '$volume',
                  style: AppTheme.theme.textTheme.displayMedium?.copyWith(fontSize: 20),
                ),
                Text(
                  label,
                  style: AppTheme.theme.textTheme.labelSmall?.copyWith(fontSize: 8),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
