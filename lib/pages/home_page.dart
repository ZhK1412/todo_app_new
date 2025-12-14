import 'package:flutter/material.dart';
import 'package:todo_app_new/pages/about_page.dart';
import 'package:todo_app_new/utils/todo_list.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = TextEditingController();
  late List toDoList;
  late Box box;

  @override
  void initState() {
    super.initState();
    box = Hive.box('todoBox');
    toDoList = box.get(
      'tasks',
      defaultValue: [
        ['Ознакомиться с приложением', false],
        ['Нажать на квадратик', false],
        ['Свайпнуть задачу и удалить', false],
      ],
    );
  }

  // List toDoList = box.get(
  //   'tasks',
  //   defaultValue: [
  //     ['Сделать приложение', false],
  //     ['Поиграть в Minecraft', false],
  //   ],
  // );

  void saveData() {
    box.put('tasks', toDoList);
  }

  void checkBoxChanged(int index) {
    setState(() {
      toDoList[index][1] = !toDoList[index][1];
    });
    saveData();
  }

  void saveNewTask() {
    if (_controller.text.isEmpty) return;
    setState(() {
      toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    saveData();
  }

  void deleteTask(int index) {
    setState(() {
      toDoList.removeAt(index);
    });
    saveData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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

      drawer: Drawer(
        child: Container(
          color: Colors.deepPurple[300],
          child: ListView(
            children: [
              DrawerHeader(
                child: Center(
                  child: Text(
                    "Список дел",
                    style: TextStyle(fontSize: 35, color: Colors.white),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home, color: Colors.white),
                title: Text(
                  "Главная",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                onTap: () {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (context) => HomePage()));
                },
              ),
              ListTile(
                leading: Icon(Icons.info, color: Colors.white),
                title: Text(
                  "О приложении",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                onTap: () {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (context) => AboutPage()));
                },
              ),
            ],
          ),
        ),
      ),

      body: ListView.builder(
        itemCount: toDoList.length,
        itemBuilder: (BuildContext context, index) {
          return TodoList(
            taskName: toDoList[index][0],
            taskCompleted: toDoList[index][1],
            onChanged: (value) => checkBoxChanged(index),
            deleteFunction: (context) => deleteTask(index),
          );
        },
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: "Что сегодня будем делать?",
                    filled: true,
                    fillColor: Colors.deepPurple.shade100,
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 185, 150, 235),
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 185, 150, 235),
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ),
            FloatingActionButton(
              onPressed: saveNewTask,
              backgroundColor: const Color.fromARGB(255, 185, 150, 235),
              child: Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
