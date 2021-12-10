import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:invest_analize/controllers/wallet_controller.dart';
import 'package:invest_analize/entities/symol_entity.dart';
import 'package:invest_analize/screens/stock_screen.dart';
import 'package:invest_analize/screens/symbols_search_screen.dart';

class HomeController extends GetxController {
  final WalletController _walletController = Get.find();
  final walletTotal = RxNum(0);

  HomeController() {
    _walletController.symbols.stream.listen(_listenStocks);
  }

  RxBool get isRefresh => _walletController.refreshingValues;

  void openSearch() async =>
      showSearch(context: Get.context!, delegate: SymbolsSearchScreen());

  void openStockScreen(SymbolEntity symbol) {
    Get.to(() => StockScreen(symbol: symbol));
  }

  void _listenStocks(List<SymbolEntity> symbols) {
    walletTotal.value = _sumWallet(symbols);
  }

  num _sumWallet(List<SymbolEntity> symbols) {
    num value = 0;
    for (var symbol in symbols) {
      value += (symbol.aquisition!.qnt * symbol.value!.price);
    }
    return value;
  }

  void updateValues() {
    _walletController.updateWallet();
  }
}
