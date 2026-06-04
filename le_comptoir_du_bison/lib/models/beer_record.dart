class BeerRecord {
  final int? id;
  final int timestamp;
  final int volume;

  BeerRecord({this.id, required this.timestamp, required this.volume});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timestamp': timestamp,
      'volume': volume,
    };
  }

  factory BeerRecord.fromMap(Map<String, dynamic> map) {
    return BeerRecord(
      id: map['id'],
      timestamp: map['timestamp'],
      volume: map['volume'],
    );
  }
}
