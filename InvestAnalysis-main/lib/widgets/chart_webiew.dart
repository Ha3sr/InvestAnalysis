import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:invest_analize/utils/get_chart_url.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:invest_analize/entities/symol_entity.dart';

class ChartWebView extends StatefulWidget {
  const ChartWebView({
    Key? key,
    required this.symbol,
  }) : super(key: key);
  final SymbolEntity symbol;

  @override
  State<ChartWebView> createState() => _ChartWebViewState();
}

class _ChartWebViewState extends State<ChartWebView>
    with AutomaticKeepAliveClientMixin {
  final loadingDone = false.obs;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        Positioned.fill(
          child: WebView(
            onProgress: _onProgress,
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: getChartUrl(
                widget.symbol, Get.theme.scaffoldBackgroundColor.value),
          ),
        ),
        Obx(() => Visibility(
              visible: !loadingDone.value,
              child: Container(
                color: const Color(0xff232222),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            )),
      ],
    );
  }

  void _onProgress(int progress) {
    if (progress == 100) {
      Future.delayed(
          const Duration(seconds: 1), () => loadingDone.value = true);
    }
  }

  @override
  bool get wantKeepAlive => true;
}
