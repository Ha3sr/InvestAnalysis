import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:invest_analize/controllers/stock_controller.dart';
import 'package:invest_analize/entities/symol_entity.dart';
import 'package:invest_analize/models/finhub/finhub_company_profile.dart';
import 'package:invest_analize/models/finhub/finhub_quote_model.dart';
import 'package:invest_analize/utils/mapper_finhub_keys.dart';
import 'package:invest_analize/widgets/chart_webiew.dart';
import 'package:invest_analize/widgets/company_logo.dart';
import 'package:invest_analize/widgets/wallet_symbol_widget.dart';

class StockScreen extends StatelessWidget {
  const StockScreen({
    Key? key,
    required this.symbol,
  }) : super(key: key);
  final SymbolEntity symbol;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StockController>(
      init: StockController(
        symbol: symbol,
      ),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: const Text(
            'Detalhes da Ação',
            maxLines: 1,
          ),
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 140),
                child: Column(
                  children: [
                    _buildHeaders(
                      controller,
                    ),
                    _buildChart(),
                    _buildOverView(controller)
                  ],
                ),
              ),
            ),
            Positioned(
                bottom: 16, left: 12, right: 12, child: _buildFab(controller))
          ],
        ),
      ),
    );
  }

  Widget _buildFab(StockController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (controller.isOnWallet)
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  padding: const EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              onPressed: controller.deletStock,
              child: const Text('Remover da Carteira')),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
            onPressed: controller.openWallet,
            child: const Text('Salvar na Carteira')),
      ],
    );
  }

  FutureBuilder<FinhubCompanyProfile> _buildOverView(
      StockController controller) {
    return FutureBuilder<FinhubCompanyProfile>(
      future: controller.getCompanyProfile,
      builder: (context, snapshotProfile) => snapshotProfile.connectionState ==
              ConnectionState.waiting
          ? const SizedBox.shrink()
          : Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(16)),
              margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: 35,
                        width: 35,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: CompanyLogo(
                              url: snapshotProfile.data?.logo,
                              radius: 35,
                              companyName: symbol.symbol),
                        ),
                      ),
                      const SizedBox(
                        width: 14,
                      ),
                      Text(
                        'Visao Geral',
                        style: Get.textTheme.subtitle2,
                      ),
                      const Expanded(child: SizedBox()),
                      if (snapshotProfile.data?.weburl != null)
                        TextButton.icon(
                            style: TextButton.styleFrom(primary: Colors.black),
                            onPressed: () => controller
                                .openCompanySite(snapshotProfile.data!.weburl!),
                            icon: const Icon(Icons.open_in_browser),
                            label: const Text('Site'))
                    ],
                  ),
                  FutureBuilder<FinhubQuoteModel>(
                      future: controller.getQuote,
                      builder: (context, snapshotQuote) =>
                          snapshotQuote.connectionState ==
                                  ConnectionState.waiting
                              ? const LinearProgressIndicator()
                              : Container(
                                  margin: const EdgeInsets.only(top: 14),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildOverviewValues(
                                          snapshotQuote.data?.openPriceOfTheDay
                                                  .toStringAsFixed(2) ??
                                              '??',
                                          'Abertura do dia'),
                                      _buildOverviewValues(
                                          snapshotQuote.data?.lowPriceOfTheDay
                                                  .toStringAsFixed(2) ??
                                              '??',
                                          'Menor do dia'),
                                      _buildOverviewValues(
                                          snapshotQuote.data?.highPriceOfTheDay
                                                  .toStringAsFixed(2) ??
                                              '??',
                                          'Maior do dia')
                                    ],
                                  ),
                                )),
                  _buildProfile(controller),
                ],
              ),
            ),
    );
  }

  Column _buildOverviewValues(String value, String title) {
    return Column(
      children: [
        Text(
          title,
          style: Get.textTheme.caption?.copyWith(color: Colors.grey),
        ),
        Text(
          '\$' + (value),
          style: Get.textTheme.subtitle2,
        ),
      ],
    );
  }

  Container _buildChart() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      width: Get.width,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: ChartWebView(symbol: symbol)),
      ),
    );
  }

  Widget _buildHeaders(StockController controller) {
    return FutureBuilder<FinhubQuoteModel>(
      future: controller.getQuote,
      builder: (context, snapshotQuote) =>
          snapshotQuote.connectionState == ConnectionState.waiting
              ? const LinearProgressIndicator()
              : FutureBuilder<FinhubCompanyProfile>(
                  future: controller.getCompanyProfile,
                  builder: (context, snapshotProfile) =>
                      snapshotProfile.connectionState == ConnectionState.waiting
                          ? const LinearProgressIndicator()
                          : WalletSymbolWidget(
                              symbol: symbol,
                              companyProfile: snapshotProfile.data,
                              quote: snapshotQuote.data,
                            ),
                ),
    );
  }

  Widget _buildProfile(StockController controller) {
    return FutureBuilder<FinhubCompanyProfile>(
        future: controller.getCompanyProfile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox.shrink();
          }
          if (snapshot.data == null) {
            return const SizedBox.shrink();
          }
          final profileMap = snapshot.data!.toMap()
            ..removeWhere((key, value) =>
                value == null ||
                key == 'logo' ||
                key == 'ticker' ||
                key == 'weburl');

          return Container(
            margin: const EdgeInsets.only(top: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...List.generate(profileMap.length, (index) {
                  String value = _getValue(profileMap, index);
                  final key = profileMap.keys.toList()[index];
                  return SelectableText.rich(
                      TextSpan(
                          text: '${FinhubKeysMapper.mapperKey(key)}: ' +
                              value +
                              '. ',
                          style: Get.textTheme.subtitle2),
                      textAlign: TextAlign.start);
                })
              ],
            ),
          );
        });
  }

  String _getValue(Map profileMap, int index) {
    String value = profileMap[profileMap.keys.toList()[index]].toString();
    final key = profileMap.keys.toList()[index];
    if (key == 'country') {
      value = FinhubKeysMapper.getCountyAlpha2(value) ?? '??';
    }
    if (key == 'ipo') {
      value = formatDate(DateTime.parse(value), [dd, '/', mm, '/', yyyy]);
    }
    if (key == 'currency') {
      value = FinhubKeysMapper.getCurrencuFromCode(value) ?? '??';
    }
    return value;
  }
}
