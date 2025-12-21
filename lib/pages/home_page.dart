import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app_new/utils/noti_service.dart';
import 'about_page.dart';
import 'package:todo_app_new/utils/todo_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = TextEditingController();
  final _notiService = NotiService();
  late List toDoList;
  late Box box;
  bool isNotiEnabled = false;

  @override
  void initState() {
    super.initState();
    box = Hive.box('todoBox');
    toDoList = box.get(
      'tasks',
      defaultValue: [
        ['Ознакомиться с приложением', false],
        ['Нажать на круг', false],
        ['Свайпнуть задачу и удалить', false],
      ],
    );
    isNotiEnabled = box.get('isNotiEnabled', defaultValue: false);
    NotiService().initNotification();
  }

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

  final List<int> _notificationIds = [1, 2, 3];

  void toggleNotifications() async {
    setState(() {
      isNotiEnabled = !isNotiEnabled;
    });

    box.put('isNotiEnabled', isNotiEnabled);

    if (isNotiEnabled) {
      await _notiService.scheduleDailyNotification(
        id: _notificationIds[0],
        title: "Доброе утро",
        body: "Пора проверить список дел на сегодня.",
        hour: 7,
        minute: 0,
      );

      await _notiService.scheduleDailyNotification(
        id: _notificationIds[1],
        title: "Добрый день",
        body: "Не забыли ли вы про свои задачи?",
        hour: 13,
        minute: 0,
      );

      await _notiService.scheduleDailyNotification(
        id: _notificationIds[2],
        title: "Добрый вечер",
        body: "Пора подвести итоги дня и отметить выполненное.",
        hour: 20,
        minute: 0,
      );

      _showSnackBar("Ежедневные уведомления включены (9:00, 14:00, 20:00)");
    } else {
      for (int id in _notificationIds) {
        await _notiService.notificationsPlugin.cancel(id);
      }
      _showSnackBar("Все уведомления отключены");
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Список дел",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(
            onPressed: toggleNotifications,
            icon: Icon(
              isNotiEnabled
                  ? Icons.notifications_active
                  : Icons.notifications_off,
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: Theme.of(context).colorScheme.primary,
          child: ListView(
            children: [
              DrawerHeader(
                child: Center(
                  child: Text(
                    "Список дел",
                    style: TextStyle(
                      fontSize: 35,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.home,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                title: Text(
                  "Главная",
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.info,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                title: Text(
                  "О приложении",
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const AboutPage()),
                  );
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
                    hintStyle: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.5),
                      fontSize: 16,
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ),
            FloatingActionButton(
              onPressed: saveNewTask,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
