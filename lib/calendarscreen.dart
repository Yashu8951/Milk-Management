import 'package:flutter/material.dart';
import 'package:milky_management/db_helper.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendarscreen extends StatefulWidget {
  const Calendarscreen({super.key});

  @override
  State<Calendarscreen> createState() => _CalendarscreenState();
}

class _CalendarscreenState extends State<Calendarscreen> {
  final DbHelper db = DbHelper();

  Map<DateTime, int> logs = {};

  final TextEditingController dateController = TextEditingController();
  final TextEditingController boughtController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  // LOAD DATA FROM DATABASE
  Future<void> _loadLogs() async {
    final data = await db.getLogs();
    final Map<DateTime, int> map = {};

    for (var entry in data) {
      try {
        DateTime date = DateTime.parse(entry['date']);
        DateTime pureDate = DateTime(date.year, date.month, date.day);
        map[pureDate] = entry['bought'];
      } catch (e) {
        debugPrint("Skipped invalid date: ${entry['date']}");
      }
    }

    setState(() {
      logs = map;
    });
  }


  Future<void> _updateLog() async {
    try {
      String date = dateController.text.trim();
      int bought = int.parse(boughtController.text.trim());

      if (bought != 0 && bought != 1) {
        throw Exception("Bought must be 0 or 1");
      }

      String message = await db.updatePrevious(date, bought);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
        ),
      );

      dateController.clear();
      boughtController.clear();

      _loadLogs();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Milk Calendar"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TableCalendar(
              focusedDay: DateTime.now(),
              firstDay: DateTime(2020),
              lastDay: DateTime(2030),
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  final value = logs[
                  DateTime(day.year, day.month, day.day)];

                  if (value == 1) {
                    return _calendarCell(day, Colors.green);
                  }

                  if (value == 0) {
                    return _calendarCell(day, Colors.red);
                  }

                  return null;
                },
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: dateController,
                keyboardType: TextInputType.datetime,
                decoration: const InputDecoration(
                  labelText: "Date (YYYY-MM-DD)",
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: boughtController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Bought (0 or 1)",
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: _updateLog,
              style:  ElevatedButton.styleFrom(minimumSize: Size(20, 40),
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(),),
              child: const Text("Update",style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }

  Widget _calendarCell(DateTime day, Color color) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(
        child: Text(
          '${day.day}',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
