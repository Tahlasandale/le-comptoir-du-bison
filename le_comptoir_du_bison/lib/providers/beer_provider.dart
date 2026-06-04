import 'package:flutter/material.dart';
import '../models/beer_record.dart';
import '../services/database_helper.dart';

class BeerProvider with ChangeNotifier {
  List<BeerRecord> _todayBeers = [];
  bool _isLoading = true;

  List<BeerRecord> get todayBeers => _todayBeers;
  bool get isLoading => _isLoading;

  int get totalVolume => _todayBeers.fold(0, (sum, item) => sum + item.volume);
  int get sessionCount => _todayBeers.length;

  double get avgGlassSize {
    if (_todayBeers.isEmpty) return 0;
    return totalVolume / _todayBeers.length;
  }

  String get peakHour {
    if (_todayBeers.isEmpty) return '—';
    Map<int, int> hourly = {};
    for (var beer in _todayBeers) {
      int hour = DateTime.fromMillisecondsSinceEpoch(beer.timestamp).hour;
      hourly[hour] = (hourly[hour] ?? 0) + beer.volume;
    }
    var sorted = hourly.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return '${sorted.first.key}h';
  }

  Future<void> fetchTodayBeers() async {
    _isLoading = true;
    notifyListeners();
    _todayBeers = await DatabaseHelper().getTodayBeers();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addBeer(int volume) async {
    final beer = BeerRecord(
      timestamp: DateTime.now().millisecondsSinceEpoch,
      volume: volume,
    );
    await DatabaseHelper().insertBeer(beer);
    await fetchTodayBeers();
  }

  Future<void> resetToday() async {
    await DatabaseHelper().deleteTodayBeers();
    await fetchTodayBeers();
  }
}
