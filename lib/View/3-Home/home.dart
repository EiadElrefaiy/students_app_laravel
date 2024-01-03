import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:students_app/View/2-Login/login.dart';
import 'package:students_app/View/5-Attendance/attendance.dart';
import 'package:students_app/View/6-Exams/exams.dart';
import 'package:students_app/View/7-StudentReport/studentReport.dart';
import 'package:students_app/View/general/appbar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String token = "";
  var results;
  String? username;
  String? studentImage;
  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    studentImage =
        "https://safrji.com/students/storage/app/public/images/${prefs.getString("image")}";
    username = prefs.getString("username");
    setState(() {});
  }

  Logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token")!;
    var url = "https://safrji.com/api/v1/admins/logout-student";
    var response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-type": "Application/json;charset=UTF-8",
        "auth-token": token
      },
    );

    results = jsonDecode(response.body);

    if (results['status'] == true) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Login()),
        (Route<dynamic> route) => false,
      );
      prefs.setInt('isLoggedIn', 1);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getUser();
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
          padding: EdgeInsets.symmetric(horizontal: 10),
          color: Colors.white,
          height: screenHeight - (screenHeight / 17.5),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 90,
                ),
                Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Color(0xFF7489A6), Color(0xFF63AFD9)],
                            begin: const FractionalOffset(0.0, 0.0),
                            end: const FractionalOffset(0.5, 0.0),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp),
                      ),
                    ),
                    Positioned(
                      top: -60,
                      child: Column(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(studentImage ??
                                      "https://media.istockphoto.com/id/1337144146/vector/default-avatar-profile-icon-vector.jpg?s=612x612&w=0&k=20&c=BIbFwuv7FxTWvh5S3vB6bkT0Qv8Vn8N5Ffseq84ClGI="),
                                  fit: BoxFit.fill),
                              color: Color.fromARGB(255, 200, 200, 200),
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            username ?? "",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            "طالب",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Card(
                        clipBehavior: Clip.hardEdge,
                        color: Color.fromARGB(255, 240, 240, 240),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: ((context) => Attendance())));
                          },
                          splashColor: Color.fromARGB(255, 220, 220, 220),
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Image.asset(
                                  "assets/images/absent.png",
                                  width: 60,
                                  height: 60,
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  "الغياب",
                                  style: TextStyle(fontSize: 15),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Card(
                        clipBehavior: Clip.hardEdge,
                        color: Color.fromARGB(255, 240, 240, 240),
                        child: InkWell(
                          splashColor: Color.fromARGB(255, 220, 220, 220),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: ((context) => Exams())));
                          },
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Image.asset(
                                  "assets/images/immigration.png",
                                  width: 50,
                                  height: 60,
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  "نتائج الاختبارات",
                                  style: TextStyle(fontSize: 15),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Card(
                        clipBehavior: Clip.hardEdge,
                        color: Color.fromARGB(255, 240, 240, 240),
                        child: InkWell(
                          splashColor: Color.fromARGB(255, 220, 220, 220),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: ((context) => StudentReport())));
                          },
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Image.asset(
                                  "assets/images/business-report.png",
                                  width: 55,
                                  height: 60,
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  "تقرير شامل",
                                  style: TextStyle(fontSize: 15),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Card(
                        clipBehavior: Clip.hardEdge,
                        color: Color.fromARGB(255, 240, 240, 240),
                        child: InkWell(
                          splashColor: Color.fromARGB(255, 220, 220, 220),
                          onTap: () {
                            Logout();
                          },
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Image.asset(
                                  "assets/images/check-out.png",
                                  width: 50,
                                  height: 60,
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  "تسجيل الخروج",
                                  style: TextStyle(fontSize: 15),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )));
  }
}
