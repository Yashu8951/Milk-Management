import 'package:flutter/material.dart';
import 'package:milky_management/db_helper.dart';

class Historypages extends StatefulWidget {
   Historypages({super.key});

  @override
  State<Historypages> createState() => _HistorypagesState();
}

class _HistorypagesState extends State<Historypages> {
  final DbHelper db = DbHelper();
  List<Map<String,dynamic>> logs = [];
  TextEditingController password = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController brought = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    load();
  }
  
  Future<String> delete() async {
    password.text;
    String adminpassword = "yash123";
    if(adminpassword==password.text) {
db.deletedate();
load();
return "done";
    } else {
      return "not done";
    }
    
  }

  void load() async{
    logs = await db.getLogs();
    setState(() {

    });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("History")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: logs.length,
              itemBuilder: (context, index) {
                final log = logs[index];
                return ListTile(
                  title: Text(log['date']),
                  trailing: Text(
                    log['bought'] == 1 ? "✔ Bought" : "✖ Not Bought",
                    style: TextStyle(
                      color: log['bought'] == 1 ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),

          // Password + Delete Section
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: password,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter password to delete all data",
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () async {
     String mess = await delete();
     if(mess == 'done') {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('done',style: TextStyle(color: Colors.black)),backgroundColor: Colors.limeAccent,));
    } else {
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mess),backgroundColor: Colors.red,));
     }



     },style:  ElevatedButton.styleFrom(minimumSize: Size(20, 40),
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(),),
                  child: const Text("Delete",style: TextStyle(color: Colors.white),),
                ),
              ],
            ),
          ),
        ],
      ),
    );

  }
}
