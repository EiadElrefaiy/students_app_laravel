import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:students_app/View/6-Exams/exams.dart';
import 'package:students_app/View/general/appbar.dart';
import 'package:http/http.dart' as http;
import 'package:students_app/View/general/appbarTeacher.dart';

class TeacherClasses extends StatefulWidget {
  const TeacherClasses({super.key});

  @override
  State<TeacherClasses> createState() => _TeacherClassesState();
}

var results;

class _TeacherClassesState extends State<TeacherClasses> {
  Future<String> getStudent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = "https://safrji.com/api/v1/admins/get-student-year";
    var response = await http.post(
      Uri.parse(url),
      body: jsonEncode({"year": prefs.getString("year_filter")}),
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
  Widget build(BuildContext context) {
    AppBar appBar = AppBar();
    double screenHeight =
        MediaQuery.of(context).size.height - appBar.preferredSize.height;

    return Scaffold(
        appBar: AppbarTeacher(),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Container(
          color: Colors.white,
          height: screenHeight - (screenHeight / 17.5),
          child: Directionality(
            textDirection: TextDirection.rtl,
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
                    var students = jsonDecode(snapshot.data as String);
                    return ListView.builder(
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        return Material(
                          color: Colors.white,
                          child: InkWell(
                            splashColor: Colors.grey,
                            child: ListTile(
                              onTap: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setInt('student_id',
                                    students["students"][index]["id"]);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: ((context) => Exams())));
                              },
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    "https://safrji.com/students/storage/app/public/images/${students["students"][index]["image"].toString()}" ??
                                        "https://safrji.com/students/storage/app/public/images/user.png"),
                              ),
                              title: Text(students["students"][index]["name"]
                                  .toString()),
                              subtitle: Text(students["students"][index]["year"]
                                  .toString()),
                            ),
                          ),
                        );
                      },
                    );
                  }
                }
              },
            ),
          ),
        )));
  }
}
