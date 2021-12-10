import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:invest_analize/controllers/wallet_controller.dart';
import 'package:invest_analize/entities/aquisition_entity.dart';
import 'package:invest_analize/entities/symol_entity.dart';
import 'package:invest_analize/entities/value_entity.dart';
import 'package:invest_analize/repositories/persistence/persistence_repository.dart';

class StockToWalletController extends GetxController {
  final PersistenceRepository _persistence = Get.find();
  final WalletController _walletController = Get.find();
  final RxNum onWalletValue = RxNum(0);
  final SymbolEntity symbol;
  final ValueEntity value;
  final formKey = GlobalKey<FormState>();
  num multiplier = 0;
  StockToWalletController({
    required this.symbol,
    required this.value,
  }) {
    _multipyValue(symbol.aquisition?.qnt.toString() ?? '');
  }

  void onChangeText(String value) {
    if (value.isEmpty) onWalletValue.value = 0;
    try {
      _multipyValue(value);
    } catch (e) {}
  }

  _multipyValue(String multiplierString) {
    multiplierString = multiplierString.replaceAll(',', '');
    multiplier = num.tryParse(multiplierString) ?? 0;

    final multipliedValue = (multiplier) * value.price;

    onWalletValue.value = multipliedValue;
  }

  String? validateField(String? value) {
    if (value?.isEmpty ?? false) return 'Insira um valor';
    if (onWalletValue.value == 0) return 'O valor inserido é inválido';
    return null;
  }

  void submitValue() async {
    if (!formKey.currentState!.validate()) return;
    final aquisition =
        AcquisitionEntity(symbol: symbol.symbol, qnt: multiplier);
    final symbolResult =
        await _persistence.insertAquisition(aquisition, symbol, value);
    _walletController.addSymbol(symbolResult);
    Get.back(result: symbolResult);
  }
}
