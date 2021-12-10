import 'package:invest_analize/entities/aquisition_entity.dart';
import 'package:invest_analize/entities/value_entity.dart';

class SymbolEntity {
  final String symbol;
  final String description;
  String? logo;
  AcquisitionEntity? aquisition;
  ValueEntity? value;

  SymbolEntity({
    required this.symbol,
    required this.description,
    this.aquisition,
    this.logo,
    this.value,
  });

  /// symbol TEXT PRIMARY KEY, description TEXT
  Map<String, dynamic> toSqfliteMap() => {
        'symbol': symbol,
        'description': description,
        'logo': logo ?? '',
      };

  factory SymbolEntity.fromSqfliteQuery(Map<String, dynamic> map) {
    return SymbolEntity(
        symbol: map['symbol'],
        description: map['description'],
        logo: map['logo']);
  }
}
