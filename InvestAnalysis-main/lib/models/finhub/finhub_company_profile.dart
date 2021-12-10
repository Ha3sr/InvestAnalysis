import 'dart:convert';

class FinhubCompanyProfile {
  final String? country;
  final String? currency;
  final String? exchange;
  final String? ipo;
  final num? marketCapitalization;
  final String? name;
  final String? phone;
  final num? shareOutstanding;
  final String? ticker;
  final String? weburl;
  final String? logo;
  final String? finnhubIndustry;
  FinhubCompanyProfile({
    required this.country,
    required this.currency,
    required this.exchange,
    required this.ipo,
    required this.marketCapitalization,
    required this.name,
    required this.phone,
    required this.shareOutstanding,
    required this.ticker,
    required this.weburl,
    required this.logo,
    required this.finnhubIndustry,
  });

  Map<String, dynamic> toMap() {
    return {
      'country': country,
      'currency': currency,
      'exchange': exchange,
      'ipo': ipo,
      'marketCapitalization': marketCapitalization,
      'name': name,
      'phone': phone,
      'shareOutstanding': shareOutstanding,
      'ticker': ticker,
      'weburl': weburl,
      'logo': logo,
      'finnhubIndustry': finnhubIndustry,
    };
  }

  factory FinhubCompanyProfile.fromMap(Map<String, dynamic> map) {
    return FinhubCompanyProfile(
      country: map['country'],
      currency: map['currency'],
      exchange: map['exchange'],
      ipo: map['ipo'],
      marketCapitalization: map['marketCapitalization'],
      name: map['name'],
      phone: map['phone'],
      shareOutstanding: map['shareOutstanding'],
      ticker: map['ticker'],
      weburl: map['weburl'],
      logo: map['logo'],
      finnhubIndustry: map['finnhubIndustry'],
    );
  }

  String toJson() => json.encode(toMap());

  factory FinhubCompanyProfile.fromJson(String source) =>
      FinhubCompanyProfile.fromMap(json.decode(source));
}
