import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:invest_analize/screens/home_page.dart';
import 'package:invest_analize/utils/set_up_dependencies.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _init(),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const LinearProgressIndicator()
                : Container(),
      ),
    );
  }

  _init() async {
    await setUpDependecies();
    Get.offAll(() => const HomePage());
  }
}
