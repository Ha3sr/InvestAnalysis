import 'dart:convert';
import 'dart:io';

import 'package:invest_analize/entities/symol_entity.dart';
import 'package:invest_analize/models/finhub/finhub_company_profile.dart';
import 'package:invest_analize/models/finhub/finhub_quote_model.dart';
import 'package:invest_analize/models/finhub/finhub_symbol_model.dart';
import 'package:invest_analize/repositories/repository.dart';
import 'package:invest_analize/const/.env.dart' as env;
import 'package:http/http.dart' as http;

class FinHubRepository implements Repository {
  final String baseApiUrl = 'https://finnhub.io/api/v1';
  final headers = {HttpHeaders.contentTypeHeader: 'application/json'};

  @override
  Future<FinhubQuoteModel> getQuote(SymbolEntity symbol) async {
    final url = Uri.parse(
        '$baseApiUrl/quote?symbol=${symbol.symbol}&token=${env.FINHUB_API_KEY}');
    final response = await http.get(url, headers: headers);
    if (response.statusCode != 200) throw response.body;
    final json = jsonDecode(response.body);
    final quote = FinhubQuoteModel.fromMap(json);
    return quote;
  }

  @override
  Future<List<SymbolEntity>> searchSymbols(String query) async {
    final url =
        Uri.parse('$baseApiUrl/search?q=$query&token=${env.FINHUB_API_KEY}');
    final response = await http.get(url, headers: headers);
    if (response.statusCode != 200) throw response.body;
    final json = jsonDecode(response.body);
    final symbols = List.from(json['result'])
        .map((e) => FinhubSymbolModel.fromMap(e))
        .toList();

    return symbols;
  }

  @override
  Future<FinhubCompanyProfile> getCompanyPorfile(SymbolEntity symbol) async {
    final url = Uri.parse(
        '$baseApiUrl/stock/profile2?symbol=${symbol.symbol}&token=${env.FINHUB_API_KEY}');
    final response = await http.get(url, headers: headers);
    if (response.statusCode != 200) throw response.body;
    final json = jsonDecode(response.body);
    final company = FinhubCompanyProfile.fromMap(json);
    return company;
  }
}
