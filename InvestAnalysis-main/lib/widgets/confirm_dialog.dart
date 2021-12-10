import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    Key? key,
    required this.message,
  }) : super(key: key);
  final String message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        message,
        style: Get.textTheme.headline6?.copyWith(
          color: Colors.black,
        ),
      ),
      actions: [
        TextButton(
            onPressed: Get.back,
            child: const Text(
              'Cancelar',
              style: TextStyle(
                color: Colors.red,
              ),
            )),
        TextButton(
            onPressed: () => Get.back(
                  result: true,
                ),
            child: const Text(
              'Confirmar',
              style: TextStyle(
                color: Colors.green,
              ),
            )),
      ],
    );
  }

  static Future<bool> show(String title) async {
    final result = await Get.dialog(ConfirmDialog(message: title));

    return result == true;
  }
}
