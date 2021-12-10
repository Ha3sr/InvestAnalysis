import 'package:invest_analize/entities/symol_entity.dart';

String getChartUrl(SymbolEntity symbol, int color) {
  return 'https://widget.finnhub.io/widgets/stocks/chart?'
      'symbol=${symbol.symbol}'
      '&watermarkColor=%23222222'
      '&backgroundColor=%23222222'
      '&textColor=white';
}
