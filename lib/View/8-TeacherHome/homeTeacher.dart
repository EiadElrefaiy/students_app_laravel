import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:students_app/View/2-Login/login.dart';
import 'package:students_app/View/9-TeacherClasses/teacherClasses.dart';
import 'package:students_app/View/general/appbar.dart';
import 'package:students_app/View/general/appbarTeacher.dart';

class HomeTeacher extends StatefulWidget {
  const HomeTeacher({super.key});

  @override
  State<HomeTeacher> createState() => _HomeState();
}

class _HomeState extends State<HomeTeacher> {
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
    var url = "https://safrji.com/api/v1/admins/logout-teacher";
    var response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-type": "Application/json;charset=UTF-8",
        "auth-token": token
      },
    );

    results = jsonDecode(response.body);

    if (results['status'] == true) {
      prefs.setInt('isLoggedIn', 1);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Login()),
        (Route<dynamic> route) => false,
      );
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
        appBar: AppbarTeacher(),
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
                  height: 80,
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
                            "مدرس",
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
                          onTap: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setString("year_filter", "اولى");
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: ((context) => TeacherClasses())));
                          },
                          splashColor: Color.fromARGB(255, 220, 220, 220),
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Image.asset(
                                  "assets/images/444319aa-58bc-4cc7-90b5-1da88f4df734-removebg-preview.png",
                                  width: 60,
                                  height: 60,
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  "الصف الاول",
                                  style: TextStyle(fontSize: 11),
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
                          onTap: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setString("year_filter", "تانية");
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: ((context) => TeacherClasses())));
                          },
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Image.asset(
                                  "assets/images/444319aa-58bc-4cc7-90b5-1da88f4df734-removebg-preview.png",
                                  width: 50,
                                  height: 60,
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  "الصف الثاني",
                                  style: TextStyle(fontSize: 11),
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
                          onTap: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setString("year_filter", "تالتة");
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: ((context) => TeacherClasses())));
                          },
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Image.asset(
                                  "assets/images/444319aa-58bc-4cc7-90b5-1da88f4df734-removebg-preview.png",
                                  width: 55,
                                  height: 60,
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  "الصف الثالث",
                                  style: TextStyle(fontSize: 11),
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
                          onTap: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setString("year_filter", "رابعة");
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: ((context) => TeacherClasses())));
                          },
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Image.asset(
                                  "assets/images/444319aa-58bc-4cc7-90b5-1da88f4df734-removebg-preview.png",
                                  width: 55,
                                  height: 60,
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  "الصف الرابع",
                                  style: TextStyle(fontSize: 11),
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
                          onTap: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setString("year_filter", "حامسة");
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: ((context) => TeacherClasses())));
                          },
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Image.asset(
                                  "assets/images/444319aa-58bc-4cc7-90b5-1da88f4df734-removebg-preview.png",
                                  width: 55,
                                  height: 60,
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  "الصف الخامس",
                                  style: TextStyle(fontSize: 11),
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
                          onTap: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setString("year_filter", "سادسة");
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: ((context) => TeacherClasses())));
                          },
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Image.asset(
                                  "assets/images/444319aa-58bc-4cc7-90b5-1da88f4df734-removebg-preview.png",
                                  width: 55,
                                  height: 60,
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  "الصف السادس",
                                  style: TextStyle(fontSize: 11),
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
