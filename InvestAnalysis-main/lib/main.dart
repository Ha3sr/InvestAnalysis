import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:invest_analize/const/themes/themes.dart';
import 'package:invest_analize/screens/splash_screen.dart';

void main() => runApp(
      App(
        key: UniqueKey(),
      ),
    );

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppThemes.mainTheme,
      title: "InvestAnalize",
      home: const SplashScreen(),
    );
  }
}
