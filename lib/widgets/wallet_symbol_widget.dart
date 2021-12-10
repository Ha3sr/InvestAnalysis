import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:invest_analize/entities/symol_entity.dart';
import 'package:invest_analize/models/finhub/finhub_company_profile.dart';
import 'package:invest_analize/models/finhub/finhub_quote_model.dart';
import 'company_logo.dart';

class WalletSymbolWidget extends StatelessWidget {
  final SymbolEntity symbol;
  final FinhubQuoteModel? quote;
  final FinhubCompanyProfile? companyProfile;
  void Function(SymbolEntity)? onTap;

  WalletSymbolWidget(
      {Key? key,
      required this.symbol,
      this.quote,
      this.companyProfile,
      this.onTap})
      : assert(
          (symbol.value == null && quote != null) ||
              (symbol.value != null && quote == null) ||
              (symbol.value != null && quote != null),
        ),
        assert(
          (symbol.logo == null && companyProfile != null) ||
              (symbol.logo != null && companyProfile == null) ||
              (symbol.logo != null && companyProfile != null),
        ),
        super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap != null ? () => onTap!(symbol) : null,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        height: 60,
        child: Row(
          children: [
            CompanyLogo(
                url: symbol.logo ?? companyProfile?.logo ?? '',
                radius: 60,
                companyName: symbol.symbol),
            const SizedBox(
              width: 14,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  symbol.symbol,
                  maxLines: 1,
                  style: Get.textTheme.subtitle1?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  symbol.description,
                  maxLines: 1,
                  style: Get.textTheme.caption?.copyWith(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            )),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  '\$' +
                      (symbol.value?.price.toStringAsFixed(2) ??
                          quote?.currentPrice.toStringAsFixed(2) ??
                          '??'),
                  style: Get.textTheme.subtitle1
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  _getChange(
                    symbol.value?.change ?? quote!.change,
                    symbol.value?.percentChange ?? quote?.percentChange,
                  ),
                  style: Get.textTheme.caption?.copyWith(
                      color: _getChangeColor(
                        symbol.value?.change ?? quote?.change,
                      ),
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis),
                ),
                if (symbol.aquisition != null && symbol.value != null)
                  Text(
                    'X${symbol.aquisition?.qnt.toStringAsFixed(2)} = \$${actionstotal.toStringAsFixed(2)}',
                    style: Get.textTheme.subtitle2?.copyWith(
                        color: _getChangeColor(
                          symbol.value?.change ?? quote?.change,
                        ),
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis),
                  )
              ],
            ))
          ],
        ),
      ),
    );
  }

  num get actionstotal => symbol.aquisition!.qnt * symbol.value!.price;

  Color _getChangeColor(num? change) {
    if (change == null) return Colors.white;
    if (change > 0) return Colors.green;
    return Colors.red;
  }

  String _getChange(num? change, num? percentChange) {
    if (change == null) return '??';
    final sBuffer = StringBuffer();
    if (change > 0) {
      sBuffer.write('\u{02191} ');
    } else {
      sBuffer.write('\u{02193} ');
    }
    sBuffer.write(change.toStringAsFixed(2));
    sBuffer.write('%');
    sBuffer.write(
      '(${percentChange?.toStringAsFixed(2) ?? '??'}%)',
    );
    return sBuffer.toString();
  }
}
