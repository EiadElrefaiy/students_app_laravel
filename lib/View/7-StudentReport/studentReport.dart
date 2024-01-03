import 'dart:convert';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:students_app/View/general/appbar.dart';

class StudentReport extends StatefulWidget {
  const StudentReport({super.key});

  @override
  State<StudentReport> createState() => _StudentReporteState();
}

class _StudentReporteState extends State<StudentReport> {
  var results;
  late int id;

  var attendance = 100;
  var absence = 0;
  var degrees = 0;
  var full_degrees = 0;

  var exams_comment = "";
  var attendance_comment = "";

  Future<String> getExams() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getInt("id")!;
    var url = "https://safrji.com/api/v1/admins/get-student-surveys";
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

  dynamic customRound(number, place) {
    var valueForPlace = pow(10, place);
    return (number * valueForPlace).round() / valueForPlace;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar();
    double screenHeight =
        MediaQuery.of(context).size.height - appBar.preferredSize.height;

    return Scaffold(
        appBar: Appbar(),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Container(
          color: Colors.white,
          height: screenHeight - (screenHeight / 17.5),
          child: SingleChildScrollView(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "تقرير شامل",
                    style: TextStyle(fontSize: 23),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: FutureBuilder<String>(
                          future:
                              getExams(), // function where you call your api
                          builder: (BuildContext context,
                              AsyncSnapshot<String> snapshot) {
                            // AsyncSnapshot<Your object type>
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                  child: CircularProgressIndicator(
                                color: Color(0xff61B1DF),
                              ));
                            } else {
                              if (snapshot.hasError)
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              else {
                                var exams = jsonDecode(snapshot.data as String);
                                degrees = exams["degrees"];
                                full_degrees = exams["full_degrees"];
                                double student_rate =
                                    (exams["degrees"] / exams["full_degrees"]) *
                                        100;

                                if (student_rate >= 0 && student_rate < 50) {
                                  exams_comment = "ضغيف";
                                } else if (student_rate >= 50 &&
                                    student_rate <= 70) {
                                  exams_comment = "مقبول";
                                } else if (student_rate > 70 &&
                                    student_rate <= 90) {
                                  exams_comment = "جيد";
                                } else {
                                  exams_comment = "ممتاز";
                                }

                                return Container(
                                  height: 220,
                                  child: PieChart(PieChartData(
                                      centerSpaceRadius: 5,
                                      borderData: FlBorderData(show: false),
                                      sectionsSpace: 2,
                                      sections: [
                                        PieChartSectionData(
                                          title: "مستوى الطالب" +
                                              "\n" +
                                              customRound(student_rate, 2)
                                                  .toString() +
                                              "%",
                                          titleStyle:
                                              TextStyle(color: Colors.white),
                                          value: customRound(student_rate, 2),
                                          color: Colors.green,
                                          radius: 80,
                                        ),
                                        PieChartSectionData(
                                          showTitle: false,
                                          titleStyle:
                                              TextStyle(color: Colors.white),
                                          value: 100 - student_rate,
                                          color: Colors.red,
                                          radius: 80,
                                        ),
                                      ])),
                                );
                              }
                            }
                          },
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: FutureBuilder<String>(
                          future:
                              getStudent(), // function where you call your api
                          builder: (BuildContext context,
                              AsyncSnapshot<String> snapshot) {
                            // AsyncSnapshot<Your object type>
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                  child: CircularProgressIndicator(
                                color: Color(0xff61B1DF),
                              ));
                            } else {
                              if (snapshot.hasError)
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              else {
                                //'${snapshot.data}'
                                var student =
                                    jsonDecode(snapshot.data as String);
                                var studentImage =
                                    'https://safrji.com/students/storage/app/public/images/' +
                                        student["student"]["image"];
                                attendance = student["student"]["attendance"];
                                absence = 100 - attendance;

                                double abesnce_rate =
                                    (student["student"]["attendance"] / 100) *
                                        100;
                                double attendance_rate = 100 - abesnce_rate;

                                if (abesnce_rate >= 0 && abesnce_rate <= 10) {
                                  attendance_comment = "ملتزم";
                                } else if (abesnce_rate > 10 &&
                                    abesnce_rate <= 20) {
                                  attendance_comment = "متوسط";
                                } else {
                                  attendance_comment = "غير ملتزم";
                                }
                                return Container(
                                  height: 220,
                                  child: PieChart(PieChartData(
                                      centerSpaceRadius: 5,
                                      borderData: FlBorderData(show: false),
                                      sectionsSpace: 2,
                                      sections: [
                                        PieChartSectionData(
                                          title: "نسبة الحضور" +
                                              "\n" +
                                              attendance_rate.toString() +
                                              "%",
                                          titleStyle:
                                              TextStyle(color: Colors.white),
                                          value: attendance_rate,
                                          color: Colors.green,
                                          radius: 80,
                                        ),
                                        PieChartSectionData(
                                          showTitle: false,
                                          titleStyle:
                                              TextStyle(color: Colors.white),
                                          value: abesnce_rate,
                                          color: Colors.red,
                                          radius: 80,
                                        ),
                                      ])),
                                );
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  FutureBuilder<String>(
                    future: getExams(), // function where you call your api
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      // AsyncSnapshot<Your object type>
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child: CircularProgressIndicator(
                          color: Color(0xff61B1DF),
                        ));
                      } else {
                        if (snapshot.hasError)
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        else {
                          //'${snapshot.data}'
                          var exams = jsonDecode(snapshot.data as String);
                          degrees = exams["degrees"];
                          full_degrees = exams["full_degrees"];
                          //'${snapshot.data}'
                          double student_rate = 0;
                          if (exams["full_degrees"] != 0) {
                            student_rate =
                                (exams["degrees"] / exams["full_degrees"]) *
                                    100;
                          }

                          if (student_rate >= 0 && student_rate < 50) {
                            exams_comment = "ضغيف";
                          } else if (student_rate >= 50 && student_rate <= 70) {
                            exams_comment = "مقبول";
                          } else if (student_rate > 70 && student_rate <= 90) {
                            exams_comment = "جيد";
                          } else {
                            exams_comment = "ممتاز";
                          }
                          return Container(
                              width: double.infinity,
                              height: 350,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    "عدد مرات الحضور : ${absence}",
                                    style: TextStyle(fontSize: 23),
                                  ),
                                  Text(
                                    "عدد مرات الغياب : ${attendance}",
                                    style: TextStyle(fontSize: 23),
                                  ),
                                  Text(
                                    "عدد درجات الطالب : ${degrees}",
                                    style: TextStyle(fontSize: 23),
                                  ),
                                  Text(
                                    "عدد الدرجات الكلي : ${full_degrees}",
                                    style: TextStyle(fontSize: 23),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        "حالة الغياب : ${attendance_comment}",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        "الحالة الدراسية : ${exams_comment}",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  )
                                ],
                              ));
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        )));
  }
}
