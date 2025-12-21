import 'package:flutter/material.dart';
import 'package:todo_app_new/pages/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app_new/pages/setup_page.dart';
import 'package:todo_app_new/theme/theme.dart';
import 'package:todo_app_new/utils/noti_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  NotiService().initNotification();

  await Hive.initFlutter();
  await Hive.openBox('todoBox');

  var box = Hive.box('todoBox');
  bool isFirstLaunch = box.get('firstLaunch', defaultValue: true);

  runApp(MyApp(isFirstLaunch: isFirstLaunch));
}

class MyApp extends StatelessWidget {
  final bool isFirstLaunch;
  const MyApp({super.key, required this.isFirstLaunch});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Список дел',
      theme: lightMode,
      darkTheme: darkMode,
      // home: SetupPage(),
      home: isFirstLaunch ? const SetupPage() : const HomePage(),
    );
  }
}
