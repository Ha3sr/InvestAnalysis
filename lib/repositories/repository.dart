import 'package:invest_analize/entities/symol_entity.dart';
import 'package:invest_analize/models/finhub/finhub_company_profile.dart';
import 'package:invest_analize/models/finhub/finhub_quote_model.dart';

abstract class Repository {
  Future<FinhubQuoteModel> getQuote(SymbolEntity symbol);

  Future<FinhubCompanyProfile> getCompanyPorfile(SymbolEntity symbol);

  Future<List<SymbolEntity>> searchSymbols(String query);
}
