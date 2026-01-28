import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:milky_management/db_helper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';


class Toady extends StatefulWidget {
   Toady({super.key});
 final DbHelper db = DbHelper();

  @override
  State<Toady> createState() => _ToadyState();
}

class _ToadyState extends State<Toady> {
  late String today = "";
  late String englishDay = DateFormat("EEEE").format(DateTime.now());
  late String day = DateFormat("EEEE").format(DateTime.now());
  final DbHelper db = DbHelper();

  void changeToKannada() {
    if(day=="Monday") {
      day = "ಸೋಮವಾರ";
    }else if(day=="Tuesday") {
      day = "ಮಂಗಳವಾರ";
    }else if(day=="Wednesday") {
      day = "ಬುಧವಾರ";
    }else if(day=="Thursday") {
      day = "ಗುರುವಾರ";
    }
    else if(day=="Friday") {
      day = "ಶುಕ್ರವಾರ";
    } else if(day == "Saturday") {
      day = "ಶನಿವಾರ";
    } else if(day == "Sunday") {
      day = "ಭಾನುವಾರ";
    }

  }

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    today =
    "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
      db.autoFillYesterday();
      changeToKannada();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(day ,style: GoogleFonts.dmSans(
        fontWeight: FontWeight.bold
      ),),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$day ($englishDay)',style:GoogleFonts.dmSans (
                fontSize: 20,fontWeight: FontWeight.w500
            ),),
            Text("Milk for Toady ($today)",style:GoogleFonts.dmSans (
              fontSize: 20,fontWeight: FontWeight.w500
            ),),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(decoration: BoxDecoration(
                color: Colors.lightBlueAccent
                  ,
                border: Border.all(width: 1.5,
                  style: BorderStyle.solid
                )
              ),
                child:
                Lottie.asset("assets/Milk.json")
              ),
            ),
            const SizedBox(height: 10,),
            ElevatedButton(onPressed: () async{
                 await db.saveLog(today, 1);
                 ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Marked as Bought",style: TextStyle(color: Colors.black),),backgroundColor: Colors.limeAccent,));
            }, style: ElevatedButton.styleFrom(
              backgroundColor: Colors.limeAccent,
                shape: RoundedRectangleBorder()
            ),child: Text("✔ Bought",style: GoogleFonts.dmSans(color: Colors.black),)),
            const SizedBox(height: 10,),
            ElevatedButton(onPressed: () async{
              await db.saveLog(today, 0);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Marked as not  Bought"),backgroundColor: Colors.red,));
            }, style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder()
            ),child: Text(" ✖ Not Bought",style: GoogleFonts.dmSans(color: Colors.white),))
          ],
        ),
      ),
    );
  }
}
