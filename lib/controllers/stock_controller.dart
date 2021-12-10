import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:invest_analize/controllers/wallet_controller.dart';

import 'package:invest_analize/entities/symol_entity.dart';
import 'package:invest_analize/entities/value_entity.dart';
import 'package:invest_analize/models/finhub/finhub_company_profile.dart';
import 'package:invest_analize/models/finhub/finhub_quote_model.dart';
import 'package:invest_analize/repositories/persistence/persistence_repository.dart';
import 'package:invest_analize/repositories/repository.dart';
import 'package:invest_analize/screens/stock_to_wallet_screen.dart';
import 'package:invest_analize/widgets/confirm_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class StockController extends GetxController {
  final SymbolEntity symbol;
  final Repository repository = Get.find();
  final WalletController _walletController = Get.find();
  final PersistenceRepository _persistence = Get.find();
  late Future<FinhubQuoteModel> getQuote;
  late Future<FinhubCompanyProfile> getCompanyProfile;
  bool isOnWallet = false;

  StockController({
    required this.symbol,
  }) {
    getQuote = repository.getQuote(symbol);
    getCompanyProfile = repository.getCompanyPorfile(symbol);
    if (symbol.aquisition != null) isOnWallet = true;
  }

  openCompanySite(String url) {
    launch(url);
  }

  void openWallet() async {
    final quote = await getQuote;
    final company = await getCompanyProfile;
    final result = await Get.to(() => StockToWalletScren(
          value: symbol.value ??
              ValueEntity(
                reference: '',
                price: quote.currentPrice,
                lastUpdate: DateTime.now(),
                change: quote.change,
                percentChange: quote.percentChange,
              ),
          symbol: symbol..logo = company.logo,
        ));
    if (result != null) {
      _showSuccessSnackBar(result as SymbolEntity);
      isOnWallet = true;
      update();
    }
  }

  void _showSuccessSnackBar(SymbolEntity symbol) {
    Get.rawSnackbar(
      message: 'Ação ${symbol.symbol} foi salva na carteira',
      backgroundColor: Colors.green,
    );
  }

  void deletStock() async {
    final result =
        await ConfirmDialog.show('Deseja remover essa ação da carteira?');
    if (result) {
      await _persistence.deletSymbol(symbol);
      _walletController.deletSymbol(symbol);
      symbol.aquisition = null;
      symbol.value = null;
      isOnWallet = false;
      update();
    }
  }
}
