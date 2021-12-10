class ValueEntity {
  final int? id;
  final num price;
  final DateTime lastUpdate;
  final String reference;
  final num change;
  final num percentChange;
  ValueEntity({
    this.id,
    required this.price,
    required this.lastUpdate,
    required this.reference,
    required this.change,
    required this.percentChange,
  });

  Map<String, dynamic> toSqfliteMap() => {
        'price': price,
        'last_update': DateTime.now().millisecondsSinceEpoch,
        'change': change,
        'percent_change': percentChange,
        'reference': reference
      };
  factory ValueEntity.fromSqFliteQuery(Map<String, dynamic> map) {
    return ValueEntity(
        price: map['price'],
        lastUpdate: DateTime.fromMillisecondsSinceEpoch(map['last_update']),
        reference: map['reference'],
        id: map['id'],
        change: map['change'],
        percentChange: map['percent_change']);
  }
}
