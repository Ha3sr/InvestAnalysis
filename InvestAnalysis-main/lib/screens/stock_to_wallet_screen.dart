import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:invest_analize/controllers/stock_to_wallet_controller.dart';

import 'package:invest_analize/entities/symol_entity.dart';
import 'package:invest_analize/entities/value_entity.dart';

class StockToWalletScren extends StatelessWidget {
  const StockToWalletScren({
    Key? key,
    required this.symbol,
    required this.value,
  }) : super(key: key);
  final SymbolEntity symbol;
  final ValueEntity value;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StockToWalletController>(
      init: StockToWalletController(
        symbol: symbol,
        value: value,
      ),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: Text(symbol.symbol),
        ),
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: SizedBox(
            width: Get.width,
            height: Get.height - 240,
            child: Column(
              children: [
                const Expanded(child: SizedBox()),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Valor da Ação',
                        style: Get.textTheme.headline6
                            ?.copyWith(color: Colors.white)),
                    Text('\$' + value.price.toStringAsFixed(2),
                        style: Get.textTheme.headline4
                            ?.copyWith(color: Colors.white)),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: Get.width * 0.6,
                      child: Form(
                        key: controller.formKey,
                        child: TextFormField(
                          initialValue:
                              (symbol.aquisition?.qnt ?? '').toString(),
                          validator: controller.validateField,
                          onChanged: controller.onChangeText,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            prefixText: 'Quantidade:',
                            hintText: 'Quantidade',
                            prefixStyle: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text('Valor na Carteira',
                        style: Get.textTheme.headline6
                            ?.copyWith(color: Colors.white)),
                    Obx(() => Text(
                        '\$' +
                            controller.onWalletValue.value.toStringAsFixed(2),
                        style: Get.textTheme.headline4
                            ?.copyWith(color: Colors.white)))
                  ],
                ),
                const Expanded(child: SizedBox()),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(11),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    onPressed: controller.submitValue,
                    child: const Text('Salvar na Carteira'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
