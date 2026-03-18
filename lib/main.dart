import 'package:flutter/material.dart';
import 'package:milky_management/BackGroundTask/background_task.dart';
import 'package:milky_management/BackGroundTask/premission.dart';
import 'package:milky_management/calendarscreen.dart';
import 'package:milky_management/historypages.dart';
import 'package:milky_management/toady.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  req();
  await BackgroundTask.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homepage(),

    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  int index = 0;
  final pages = [
    Toady(),
    Calendarscreen(),
    Historypages()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index] ,

      bottomNavigationBar: BottomNavigationBar(
          currentIndex: index,
          onTap: (i) {
            setState(() {
              index = i;
            });
          }
          ,
          items: const[
        BottomNavigationBarItem(icon: Icon(Icons.today),label: "Today"),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_month),label: "Calendar"),
        BottomNavigationBarItem(icon: Icon(Icons.list),label: "History"),
      ]),
    );
  }
}

