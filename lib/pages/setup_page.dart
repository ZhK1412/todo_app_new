import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'home_page.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({super.key});

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  late Box box;

  @override
  void initState() {
    super.initState();
    box = Hive.box('todoBox');
  }

  void finishSetup() {
    box.put('firstLaunch', false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        toolbarHeight: 80,
        title: const Text(
          "Список дел",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
        backgroundColor: const Color.fromARGB(255, 163, 133, 214),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Добро пожаловать!",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                // shadows: [
                //   Shadow(
                //     offset: Offset(2, 2),
                //     blurRadius: 2,
                //     color: Colors.black,
                //   ),
                // ],
              ),
            ),
            SizedBox(height: 20),
            FloatingActionButton.extended(
              onPressed: finishSetup,
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Продолжить"),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_circle_right_outlined),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
