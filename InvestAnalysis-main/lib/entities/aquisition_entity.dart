class AcquisitionEntity {
  int? id;
  final String symbol;
  final num qnt;

  AcquisitionEntity({
    this.id,
    required this.symbol,
    required this.qnt,
  });

  Map<String, dynamic> toSqfliteMap() => {
        'symbol': symbol,
        'qnt': qnt,
        'created_at': DateTime.now().millisecondsSinceEpoch
      };

  factory AcquisitionEntity.fromSqFliteQuery(Map<String, dynamic> map) {
    return AcquisitionEntity(
        symbol: map['symbol'], qnt: map['qnt'], id: map['id']);
  }
}
