import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class EmptyWalletWidget extends StatelessWidget {
  final void Function() onTap;
  const EmptyWalletWidget({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 120, child: Image.asset('assets/epty_wallet.png')),
          Container(
            margin: const EdgeInsets.all(8),
            child: Text(
              'Sua carteira está vazia',
              style: Get.textTheme.headline5?.copyWith(color: Colors.white),
            ),
          ),
          ElevatedButton(onPressed: onTap, child: const Text('Procurar Ações'))
        ],
      ),
    );
  }
}
