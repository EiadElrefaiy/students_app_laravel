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
import 'package:students_app/View/general/appbarTeacher.dart';

class Exams extends StatefulWidget {
  const Exams({super.key});

  @override
  State<Exams> createState() => _ExamseState();
}

class _ExamseState extends State<Exams> {
  var results;
  late int id;
  AppBar? _appBar;
  var app_bar;
  bool isLoading = false;

  getAppbar() async {
    setState(() {
      bool isLoading = false;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    app_bar = prefs.getInt('isLoggedIn');
    setState(() {
      bool isLoading = true;
    });
  }

  Future<String> getExams() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user = prefs.getInt('isLoggedIn');
    var id;
    var type;
    if (user == 3) {
      id = prefs.getInt("student_id")!;
      type = "teacher";
      _appBar = AppbarTeacher();
    } else {
      id = prefs.getInt("id")!;
      type = "student";
      _appBar = Appbar();
    }
    var url = "https://safrji.com/api/v1/admins/get-student-surveys";
    var response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        "id": id,
        "type": type,
        "subject": prefs.getString("subject") ?? "",
      }),
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
    getAppbar();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar();
    double screenHeight =
        MediaQuery.of(context).size.height - appBar.preferredSize.height;

    return Scaffold(
        appBar: app_bar == 3 ? AppbarTeacher() : Appbar(),
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
                          double student_rate = 0;
                          if (exams["full_degrees"] != 0) {
                            student_rate =
                                (exams["degrees"] / exams["full_degrees"]) *
                                    100;
                          }

                          return Column(
                            children: [
                              // Text(employee["empolyeeAttendance"][1]["money"].toString()),
                              FittedBox(
                                child: DataTable(
                                  headingTextStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                      letterSpacing: 0.0,
                                      color: Colors.white),
                                  headingRowColor:
                                      MaterialStateColor.resolveWith(
                                    (states) => Colors.green,
                                  ),
                                  columns: const <DataColumn>[
                                    DataColumn(
                                      label: Expanded(
                                        child: Text(
                                          'المادة',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                        child: Text(
                                          'السنة',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                        child: Text(
                                          'العنوان',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                        child: Text(
                                          'الدرجة',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                        child: Text(
                                          'الدرجة القصوى',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                    ),
                                  ],
                                  rows: exams["results"]
                                      .map<DataRow>(
                                        (exams) => DataRow(
                                          cells: <DataCell>[
                                            DataCell(Text(
                                                exams["subject"].toString())),
                                            DataCell(Text(
                                                '${exams["year"].toString()}')),
                                            DataCell(Text(
                                                '${exams["title"].toString()}')),
                                            DataCell(Text(
                                                '${exams["degree"].toString()} ')),
                                            DataCell(Text(
                                                '${exams["full_degree"].toString()} ')),
                                          ],
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                              SizedBox(
                                height: 20,
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
                                        title: "مستوى الطالب" +
                                            "\n" +
                                            customRound(student_rate, 2)
                                                .toString() +
                                            "%",
                                        titleStyle:
                                            TextStyle(color: Colors.white),
                                        value: customRound(student_rate, 2),
                                        color: Colors.green,
                                        radius: 100,
                                      ),
                                      PieChartSectionData(
                                        showTitle: false,
                                        titleStyle:
                                            TextStyle(color: Colors.white),
                                        value: 100 - student_rate,
                                        color: Colors.red,
                                        radius: 100,
                                      ),
                                    ])),
                              ),
                            ],
                          ); // snapshot.data  :- get your object which is pass from your downloadData() function
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
