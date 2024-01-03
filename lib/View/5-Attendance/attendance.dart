import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:students_app/View/general/appbar.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  var results;
  late int id;
  late String username;
  bool isLoading = false;
  String error = "";
  File? pickedImage;
  bool isPicked = false;

  int fullAttendance = 100;

  Future<String> getStudent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getInt("id")!;
    var url = "https://safrji.com/api/v1/admins/get-student-id";
    var response = await http.post(
      Uri.parse(url),
      body: jsonEncode({"id": id}),
      headers: {
        "Content-type": "Application/json;charset=UTF-8",
      },
    );
    if (response.statusCode == 200) {
      results = response.body;
      print(results);
    }
    return results;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar();
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Scaffold(
      appBar: Appbar(),
      backgroundColor: Colors.white,
      body: Center(
          child: FutureBuilder<String>(
        future: getStudent(), // function where you call your api
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          // AsyncSnapshot<Your object type>
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: Color(0xff61B1DF),
            ));
          } else {
            if (snapshot.hasError)
              return Center(child: Text('Error: ${snapshot.error}'));
            else {
              //'${snapshot.data}'
              var student = jsonDecode(snapshot.data as String);
              var studentImage =
                  'http://127.0.0.1:8000/students/storage/app/public/images/' +
                      student["student"]["image"];

              double abesnce_rate =
                  (student["student"]["attendance"] / 100) * 100;
              double attendance_rate = 100 - abesnce_rate;

              String comment = "";
              if (abesnce_rate > 0 && abesnce_rate <= 10) {
                comment = "ملتزم";
              } else if (abesnce_rate > 10 && abesnce_rate <= 20) {
                comment = "متوسط";
              } else {
                comment = "غير ملتزم";
              }

              return SingleChildScrollView(
                  child: Column(
                children: [
                  Text(
                    "تقرير الغياب",
                    style: TextStyle(fontSize: 25),
                  ),
                  Container(
                    width: 300,
                    height: 300,
                    child: PieChart(PieChartData(
                        centerSpaceRadius: 5,
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 2,
                        sections: [
                          PieChartSectionData(
                            title:
                                "نسبة الغياب" + "\n" + abesnce_rate.toString(),
                            titleStyle: TextStyle(color: Colors.white),
                            value: abesnce_rate,
                            color: Colors.red,
                            radius: 100,
                          ),
                          PieChartSectionData(
                            title: "نسبة الحضور" +
                                "\n" +
                                attendance_rate.toString(),
                            titleStyle: TextStyle(color: Colors.white),
                            value: attendance_rate,
                            color: Colors.green,
                            radius: 100,
                          ),
                        ])),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "مرات الحضور : ${100 - student["student"]["attendance"]}",
                        style: TextStyle(fontSize: 18, color: Colors.green),
                      ),
                      Text(
                        "مرات الغياب : ${student["student"]["attendance"]}",
                        style: TextStyle(fontSize: 18, color: Colors.red),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    "حالة الغياب : ${comment}",
                    style: TextStyle(fontSize: 25),
                  ),
                ],
              ));
            }
          }
        },
      )),
    );
  }
}


            /*
              FutureBuilder<String>(
                future: getStudent(), // function where you call your api
                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                  // AsyncSnapshot<Your object type>
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(
                      color: Color(0xff61B1DF),
                    ));
                  } else {
                    if (snapshot.hasError)
                      return Center(child: Text('Error: ${snapshot.error}'));
                    else {
                      //'${snapshot.data}'
                      var student = jsonDecode(snapshot.data as String);
                      var studentImage =
                          'http://127.0.0.1:8000/students/storage/app/public/images/' +
                              student["student"]["image"];
      
                      return SingleChildScrollView(
            child: Column(
          children: [
            Text(
              "تقرير الغياب",
              style: TextStyle(fontSize: 25),
            ),
            Container(
              width: 300,
              height: 300,
              child: PieChart(PieChartData(
                  centerSpaceRadius: 5,
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 2,
                  sections: [
                    PieChartSectionData(
                      title: "نسبة الغياب" + "\n" + 35.toString(),
                      titleStyle: TextStyle(color: Colors.white),
                      value: 35,
                      color: Colors.red,
                      radius: 100,
                    ),
                    PieChartSectionData(
                      title: "نسبة الحضور" + "\n" + 65.toString(),
                      titleStyle: TextStyle(color: Colors.white),
                      value: 65,
                      color: Colors.green,
                      radius: 100,
                    ),
                  ])),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "مرات الحضور : 65",
                  style: TextStyle(fontSize: 18, color: Colors.green),
                ),
                Text(
                  "مرات الغياب : 35",
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              "حالة الغياب : عالية",
              style: TextStyle(fontSize: 25),
            ),
          ],
        )

            );
                    }
                  }
                },
               )
               */
