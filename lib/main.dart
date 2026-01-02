import 'package:flutter/material.dart';
import 'package:flutter_arch/data/locator/locator.dart';
import 'package:flutter_arch/data/services/hive_box_service.dart';
import 'package:flutter_arch/ui/screens/home_screen.dart';
import 'package:flutter_arch/ui/screens/homescreen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator(); //Get.it kayıt
  await HiveBoxService.init();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Proje Yönetimi',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      //home: const MyHomePage(title: 'Flutter Arch APP'),
      home: MyHomePageT(),
    );
  }
}
