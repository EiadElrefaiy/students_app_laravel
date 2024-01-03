import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:students_app/View/general/appbarTeacher.dart';

class ProfileTeacher extends StatefulWidget {
  const ProfileTeacher({super.key});

  @override
  State<ProfileTeacher> createState() => _ProfileTeachereState();
}

class _ProfileTeachereState extends State<ProfileTeacher> {
  var results;
  late int id;
  late String username;
  bool isLoading = false;
  String error = "";
  File? pickedImage;
  bool isPicked = false;

  Future<String> getStudent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getInt("id")!;
    var url = "https://safrji.com/api/v1/admins/get-teacher-id";
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
      appBar: AppbarTeacher(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
            padding:
                EdgeInsets.symmetric(horizontal: 15 * fem, vertical: 40 * fem),
            color: Colors.white,
            height: 800 * fem,
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
                        'https://safrji.com/students/storage/app/public/images/' +
                            student["teacher"]["image"];

                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Form(
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      width: 140,
                                      height: 140,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(studentImage),
                                            fit: BoxFit.fill),
                                        color:
                                            Color.fromARGB(255, 200, 200, 200),
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                    ),
                                  ],
                                ),
                                Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "اسم المستخدم",
                                        style:
                                            TextStyle(color: Color(0xff61B1DF)),
                                      ),
                                      SizedBox(
                                        height: 40,
                                        child: TextFormField(
                                          readOnly: true,
                                          decoration: InputDecoration(
                                              disabledBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 143, 143, 143),
                                                      width: 1)),
                                              enabledBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 143, 143, 143),
                                                      width: 1)),
                                              focusedBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 143, 143, 143),
                                                      width: 1)),
                                              hintText: student["teacher"]
                                                      ["name"]
                                                  .toString()),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("الاسم على النظام",
                                          style: TextStyle(
                                              color: Color(0xff61B1DF))),
                                      SizedBox(
                                        height: 40,
                                        child: TextFormField(
                                          readOnly: true,
                                          decoration: InputDecoration(
                                              disabledBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 143, 143, 143),
                                                      width: 1)),
                                              enabledBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 143, 143, 143),
                                                      width: 1)),
                                              focusedBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 143, 143, 143),
                                                      width: 1)),
                                              hintText: student["teacher"]
                                                      ["username"]
                                                  .toString()),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("المادة الدراسية",
                                          style: TextStyle(
                                              color: Color(0xff61B1DF))),
                                      SizedBox(
                                        height: 40,
                                        child: TextFormField(
                                          readOnly: true,
                                          decoration: InputDecoration(
                                              disabledBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 143, 143, 143),
                                                      width: 1)),
                                              enabledBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 143, 143, 143),
                                                      width: 1)),
                                              focusedBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 143, 143, 143),
                                                      width: 1)),
                                              hintText: student["teacher"]
                                                      ["subject"]
                                                  .toString()),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                }
              },
            )),
      ),
    );
  }
}
