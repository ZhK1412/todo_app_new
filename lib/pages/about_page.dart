import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Icon(Icons.perm_identity_rounded, size: 52),
            Text("Создал ученик 10А класса", style: TextStyle(fontSize: 24)),
            Text(
              "Жигжитов Ким",
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
