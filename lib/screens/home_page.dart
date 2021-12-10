import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:invest_analize/controllers/home_controller.dart';
import 'package:invest_analize/controllers/wallet_controller.dart';
import 'package:invest_analize/widgets/empty_wallet_widget.dart';
import 'package:invest_analize/widgets/wallet_symbol_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    Get.put<WalletController>(WalletController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Carteira'),
          actions: [
            Obx(() => controller.isRefresh.value
                ? const Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(),
                    ),
                  )
                : IconButton(
                    onPressed: controller.updateValues,
                    icon: const Icon(Icons.refresh),
                  )),
            IconButton(
              onPressed: controller.openSearch,
              icon: const Icon(
                Icons.add,
              ),
            )
          ],
          bottom: _buildAppbarBottom(controller),
        ),
        body: Column(
          children: [
            Expanded(
              child: GetBuilder<WalletController>(
                builder: (walletController) =>
                    Obx(() => walletController.symbols.isEmpty
                        ? Center(
                            child: EmptyWalletWidget(
                            onTap: controller.openSearch,
                          ))
                        : ListView.builder(
                            itemCount: walletController.symbols.length,
                            itemBuilder: (context, index) => WalletSymbolWidget(
                              symbol: walletController.symbols.reversed
                                  .toList()[index],
                              onTap: controller.openStockScreen,
                            ),
                          )),
              ),
            )
          ],
        ),
      ),
    );
  }

  PreferredSize _buildAppbarBottom(HomeController controller) {
    const double height = 70;
    return PreferredSize(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: SizedBox(
            height: height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  formatDate(DateTime.now(), [dd, '/', mm, '/', yyyy]),
                  style: Get.textTheme.headline6?.copyWith(color: Colors.white),
                ),
                Obx(() => Text(
                      'Total: \$' +
                          controller.walletTotal.value.toStringAsFixed(2),
                      style: Get.textTheme.headline6
                          ?.copyWith(color: Colors.white),
                    ))
              ],
            ),
          ),
        ),
        preferredSize: Size(Get.width, height));
  }
}
