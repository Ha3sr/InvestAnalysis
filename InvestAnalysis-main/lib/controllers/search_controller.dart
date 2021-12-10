import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:invest_analize/controllers/wallet_controller.dart';
import 'package:invest_analize/entities/symol_entity.dart';
import 'package:invest_analize/repositories/repository.dart';
import 'package:get/route_manager.dart';
import 'package:invest_analize/screens/stock_screen.dart';

class SearchController extends GetxController {
  final Repository repository = Get.find();
  final WalletController _walletController = Get.find();
  final isLooking = false.obs;
  final symbols = <SymbolEntity>[].obs;
  final isScrollButtonVisible = false.obs;
  final scrolController = ScrollController();
  String? _queryValues;

  SearchController() {
    scrolController.addListener(_scrollListner);
  }

  Future<void> query(String query) async {
    _queryValues = query;
    if (isLooking.value) return;
    isLooking.value = true;
    final result = await repository.searchSymbols(query);
    symbols.clear();
    symbols.addAll(result);
    isLooking.value = false;
    if (_queryValues != query && _queryValues != null) {
      this.query(_queryValues!);
    }
  }

  void _scrollListner() {
    final position = scrolController.position.pixels;
    isScrollButtonVisible.value = position > Get.height * 1.4;
  }

  void scrollToTop() {
    scrolController.animateTo(0,
        duration: const Duration(seconds: 1), curve: Curves.linear);
  }

  void openStockScreen(SymbolEntity symbol) {
    Get.to(() => StockScreen(symbol: _checkSymbol(symbol)));
  }

  SymbolEntity _checkSymbol(SymbolEntity symbolEntity) {
    try {
      return _walletController.symbols
          .firstWhere((element) => element.symbol == symbolEntity.symbol);
    } catch (e) {
      return symbolEntity;
    }
  }
}
