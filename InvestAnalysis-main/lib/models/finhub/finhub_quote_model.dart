import 'dart:convert';

class FinhubQuoteModel {
  /// c

  final num currentPrice;

  /// d

  final num change;

  /// dp

  final num percentChange;

  /// h

  final num highPriceOfTheDay;

  /// l

  final num lowPriceOfTheDay;

  /// o

  final num openPriceOfTheDay;

  /// pc

  final num previousClosePrice;

  FinhubQuoteModel({
    required this.currentPrice,
    required this.change,
    required this.percentChange,
    required this.highPriceOfTheDay,
    required this.lowPriceOfTheDay,
    required this.openPriceOfTheDay,
    required this.previousClosePrice,
  });

  factory FinhubQuoteModel.fromMap(Map<String, dynamic> map) {
    return FinhubQuoteModel(
      currentPrice: map['c'],
      change: map['d'],
      percentChange: map['dp'],
      highPriceOfTheDay: map['h'],
      lowPriceOfTheDay: map['l'],
      openPriceOfTheDay: map['o'],
      previousClosePrice: map['pc'],
    );
  }

  factory FinhubQuoteModel.fromJson(String source) =>
      FinhubQuoteModel.fromMap(json.decode(source));
}
