import 'package:invest_analize/entities/symol_entity.dart';

class FinhubSymbolModel extends SymbolEntity {
  final String description;
  final String displaySymbol;
  final String symbol;
  final String type;

  FinhubSymbolModel({
    required this.description,
    required this.displaySymbol,
    required this.symbol,
    required this.type,
  }) : super(
          symbol: symbol,
          description: description,
        );

  factory FinhubSymbolModel.fromMap(Map<String, dynamic> map) {
    return FinhubSymbolModel(
      description: map['description'],
      displaySymbol: map['displaySymbol'],
      symbol: map['symbol'],
      type: map['type'],
    );
  }
}
