import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:invest_analize/entities/symol_entity.dart';
import 'package:invest_analize/entities/value_entity.dart';
import 'package:invest_analize/repositories/persistence/persistence_repository.dart';
import 'package:invest_analize/repositories/repository.dart';

class WalletController extends GetxController {
  final PersistenceRepository persistence = Get.find();
  final Repository repository = Get.find();
  final symbols = <SymbolEntity>[].obs;
  final refreshingValues = false.obs;
  WalletController() {
    _init();
  }
  _init() async {
    await _getSymbols();
    updateWallet();
  }

  _getSymbols() async {
    symbols.clear();
    final list = await persistence.getAquisitionsWallet();
    symbols.addAll(list);
  }

  void addSymbol(SymbolEntity symbol) {
    symbols.removeWhere((element) => element.symbol == symbol.symbol);
    symbols.add(symbol);
  }

  void deletSymbol(SymbolEntity symbol) {
    symbols.removeWhere((element) => element.symbol == symbol.symbol);
  }

  updateWallet() async {
    refreshingValues.value = true;
    for (var symbol in symbols) {
      final quote = await repository.getQuote(symbol);
      final value = ValueEntity(
          price: quote.currentPrice,
          lastUpdate: DateTime.now(),
          reference: symbol.symbol,
          change: quote.change,
          percentChange: quote.percentChange);
      await persistence.insertValue(value);
    }
    _getSymbols();
    refreshingValues.value = false;
  }
}
