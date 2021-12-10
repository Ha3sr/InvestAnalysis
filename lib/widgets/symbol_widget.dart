import 'package:flutter/material.dart';

import 'package:invest_analize/entities/symol_entity.dart';

class SymbolWidget extends StatelessWidget {
  final SymbolEntity symbol;
  final void Function() onTap;
  const SymbolWidget({
    Key? key,
    required this.symbol,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 12,
      ),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            color: Colors.white,
          ),
          borderRadius: BorderRadius.circular(
            12,
          ),
        ),
        title: Text(
          symbol.symbol,
          maxLines: 1,
        ),
        subtitle: Text(
          symbol.description,
          maxLines: 1,
        ),
      ),
    );
  }
}
