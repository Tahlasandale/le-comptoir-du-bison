import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'providers/beer_provider.dart';
import 'theme/app_theme.dart';
import 'widgets/beer_button.dart';
import 'widgets/cumulative_chart.dart';
import 'widgets/hourly_chart.dart';
import 'widgets/mug_widget.dart';
import 'widgets/share_summary_widget.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => BeerProvider()..fetchTodayBeers(),
      child: const BisonApp(),
    ),
  );
}

class BisonApp extends StatelessWidget {
  const BisonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Le Comptoir du Bison',
      theme: AppTheme.theme,
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<BeerProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 48, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // MASTHEAD
                _buildMasthead(provider),
                const SizedBox(height: 24),
                
                // TOTAL COUNTER
                _buildCounter(context, provider),
                const SizedBox(height: 24),

                // BEER BUTTONS
                _buildSectionHeading('Choisir son contenant'),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 1,
                  children: [
                    BeerButton(
                      volume: 25,
                      label: 'cl — Demi',
                      icon: _buildDemiIcon(),
                      onTap: () => provider.addBeer(25),
                    ),
                    BeerButton(
                      volume: 33,
                      label: 'cl — Canette',
                      icon: _buildCanetteIcon(),
                      onTap: () => provider.addBeer(33),
                    ),
                    BeerButton(
                      volume: 50,
                      label: 'cl — Pinte',
                      icon: _buildPinteIcon(),
                      onTap: () => provider.addBeer(50),
                    ),
                    BeerButton(
                      volume: 100,
                      label: 'cl — Le Litron',
                      icon: _buildLitronIcon(),
                      onTap: () => provider.addBeer(100),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                const Center(
                  child: Text(
                    '— ✦ —',
                    style: TextStyle(color: AppTheme.aged, fontSize: 20, letterSpacing: 4),
                  ),
                ),
                const SizedBox(height: 24),

                // CHARTS
                _buildSectionHeading('Tableau de bord de la soirée'),
                const SizedBox(height: 12),
                _buildChartCard('Consommation par heure', HourlyChart(beers: provider.todayBeers)),
                const SizedBox(height: 16),
                _buildChartCard('Courbe d\'ébriété cumulative', CumulativeChart(beers: provider.todayBeers)),
                
                const SizedBox(height: 24),
                
                // SHARE BUTTON
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () => _shareScore(provider),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.amber,
                      border: Border.all(color: AppTheme.brownMid, width: 3),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.share, color: AppTheme.brownDark),
                        const SizedBox(width: 12),
                        Text(
                          'PARTAGER MON SCORE',
                          style: AppTheme.theme.textTheme.labelSmall?.copyWith(
                            color: AppTheme.brownDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),
                _buildFooter(),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _shareScore(BeerProvider provider) async {
    final image = await screenshotController.captureFromWidget(
      Material(
        child: ShareSummaryWidget(
          beers: provider.todayBeers,
          totalVolume: provider.totalVolume,
          sessionCount: provider.sessionCount,
          peakHour: provider.peakHour,
          avgGlassSize: provider.avgGlassSize,
        ),
      ),
      pixelRatio: 2.0,
    );

    final directory = await getTemporaryDirectory();
    final imagePath = await File('${directory.path}/bison_score.png').create();
    await imagePath.writeAsBytes(image);

    await Share.shareXFiles([XFile(imagePath.path)], text: 'Mon score d\'hydratation houblonnée au Comptoir du Bison ! 🍻');
  }

  Widget _buildMasthead(BeerProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cream,
        border: const Border(
          top: BorderSide(color: AppTheme.brownMid, width: 6),
          bottom: BorderSide(color: AppTheme.brownMid, width: 3),
          left: BorderSide(color: AppTheme.brownMid, width: 3),
          right: BorderSide(color: AppTheme.brownMid, width: 3),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(child: Divider(color: AppTheme.brownMid)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'Brasserie Artisanale — Depuis 1847',
                  style: AppTheme.theme.textTheme.labelSmall?.copyWith(fontSize: 8),
                ),
              ),
              const Expanded(child: Divider(color: AppTheme.brownMid)),
            ],
          ),
          const SizedBox(height: 8),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Le Comptoir\ndu ',
                  style: AppTheme.theme.textTheme.displayLarge,
                ),
                TextSpan(
                  text: 'Bison',
                  style: AppTheme.theme.textTheme.displayLarge?.copyWith(
                    color: AppTheme.amber,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Registre Officiel d\'Hydratation Houblonnée',
            textAlign: TextAlign.center,
            style: AppTheme.theme.textTheme.labelSmall,
          ),
          const SizedBox(height: 16),
          const Divider(color: AppTheme.aged, thickness: 1, indent: 20, endIndent: 20),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBadgeItem('${provider.sessionCount}', 'Tournées'),
                _buildBadgeItem(provider.peakHour, 'Heure de Pointe'),
                _buildBadgeItem('${provider.avgGlassSize.round()}cl', 'Format Moyen'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeItem(String value, String label) {
    return Column(
      children: [
        Text(value, style: AppTheme.theme.textTheme.displayMedium?.copyWith(fontSize: 18)),
        Text(label, style: AppTheme.theme.textTheme.labelSmall?.copyWith(fontSize: 8)),
      ],
    );
  }

  Widget _buildCounter(BuildContext context, BeerProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.parchment,
        border: Border.all(color: AppTheme.brownMid, width: 2),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text('Volume consommé aujourd\'hui', style: AppTheme.theme.textTheme.labelSmall),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${provider.totalVolume}',
                style: AppTheme.theme.textTheme.displayLarge?.copyWith(fontSize: 64),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12, left: 4),
                child: Text('cl', style: AppTheme.theme.textTheme.displayMedium?.copyWith(color: AppTheme.amber)),
              ),
            ],
          ),
          Text(
            'Soit ${(provider.totalVolume / 100).toStringAsFixed(2)} litre${provider.totalVolume >= 200 ? 's' : ''}',
            style: AppTheme.theme.textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic, color: AppTheme.brownLight),
          ),
          const SizedBox(height: 20),
          MugWidget(fillPercent: provider.totalVolume / 300),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => _showResetDialog(context, provider),
            child: const Text(
              '✕ Réinitialiser la journée',
              style: TextStyle(
                color: AppTheme.rust,
                decoration: TextDecoration.underline,
                fontFamily: 'Special Elite',
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context, BeerProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.parchment,
        title: const Text('Seigneur Bison ?', style: TextStyle(fontFamily: 'Playfair Display')),
        content: const Text('Effacer le compteur du jour ?', style: TextStyle(fontFamily: 'Libre Baskerville')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('NON')),
          TextButton(
            onPressed: () {
              provider.resetToday();
              Navigator.pop(context);
            },
            child: const Text('OUI, EFFACER', style: TextStyle(color: AppTheme.rust)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeading(String title) {
    return Row(
      children: [
        const Text('◆', style: TextStyle(color: AppTheme.amber, fontSize: 8)),
        const SizedBox(width: 8),
        Text(title, style: AppTheme.theme.textTheme.labelSmall?.copyWith(color: AppTheme.cream)),
        const SizedBox(width: 8),
        Expanded(child: Divider(color: AppTheme.cream.withOpacity(0.2))),
      ],
    );
  }

  Widget _buildChartCard(String title, Widget chart) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.parchment,
        border: Border.all(color: AppTheme.brownMid, width: 2),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(title, style: AppTheme.theme.textTheme.labelSmall),
          const SizedBox(height: 16),
          SizedBox(height: 200, child: chart),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Divider(color: AppTheme.cream.withOpacity(0.2)),
        const SizedBox(height: 16),
        Text(
          'Brasserie Artisanale du Bison — Hydratation Responsable',
          style: AppTheme.theme.textTheme.labelSmall?.copyWith(fontSize: 8, color: AppTheme.cream.withOpacity(0.3)),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(border: Border.all(color: AppTheme.amber.withOpacity(0.6))),
          child: Text(
            'Approuvé par le Maître Brasseur',
            style: AppTheme.theme.textTheme.labelSmall?.copyWith(fontSize: 8, color: AppTheme.amber.withOpacity(0.6)),
          ),
        ),
      ],
    );
  }

  // Helper icons as widgets
  Widget _buildDemiIcon() {
    return CustomPaint(
      painter: IconPainter(type: 'demi'),
      size: const Size(36, 54),
    );
  }
  Widget _buildCanetteIcon() {
    return CustomPaint(
      painter: IconPainter(type: 'canette'),
      size: const Size(36, 54),
    );
  }
  Widget _buildPinteIcon() {
    return CustomPaint(
      painter: IconPainter(type: 'pinte'),
      size: const Size(36, 58),
    );
  }
  Widget _buildLitronIcon() {
    return CustomPaint(
      painter: IconPainter(type: 'litron'),
      size: const Size(36, 58),
    );
  }
}

class IconPainter extends CustomPainter {
  final String type;
  IconPainter({required this.type});

  @override
  void paint(Canvas canvas, Size size) {
    final paintFill = Paint()..color = AppTheme.amber.withOpacity(0.25)..style = PaintingStyle.fill;
    final paintStroke = Paint()..color = AppTheme.brownMid..style = PaintingStyle.stroke..strokeWidth = 1.5;

    if (type == 'demi') {
      final path = Path()
        ..moveTo(12, 8)..lineTo(8, 52)..quadraticBezierTo(8, 56, 12, 56)
        ..lineTo(28, 56)..quadraticBezierTo(32, 56, 32, 52)..lineTo(28, 8)..close();
      canvas.drawPath(path, paintFill);
      canvas.drawPath(path, paintStroke);
    } else if (type == 'canette') {
      final rect = RRect.fromRectAndRadius(const Rect.fromLTWH(10, 6, 20, 44), const Radius.circular(3));
      canvas.drawRRect(rect, paintFill);
      canvas.drawRRect(rect, paintStroke);
    } else if (type == 'pinte') {
      final path = Path()
        ..moveTo(10, 10)..lineTo(10, 56)..quadraticBezierTo(10, 60, 14, 60)
        ..lineTo(26, 60)..quadraticBezierTo(30, 60, 30, 56)..lineTo(30, 10)..close();
      canvas.drawPath(path, paintFill);
      canvas.drawPath(path, paintStroke);
      // Handle
      final hPath = Path()..moveTo(30, 22)..quadraticBezierTo(38, 22, 38, 32)..quadraticBezierTo(38, 42, 30, 42);
      canvas.drawPath(hPath, paintStroke);
    } else {
      final path = Path()
        ..moveTo(8, 12)..lineTo(10, 58)..quadraticBezierTo(10, 62, 15, 62)
        ..lineTo(25, 62)..quadraticBezierTo(30, 62, 30, 58)..lineTo(32, 12)..close();
      canvas.drawPath(path, paintFill);
      canvas.drawPath(path, paintStroke);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
