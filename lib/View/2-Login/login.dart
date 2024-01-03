import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:students_app/View/8-TeacherHome/homeTeacher.dart';
import 'package:students_app/View/4-profile/profile.dart';

import '../3-Home/home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

int _radioSelected = 2;
String _radioVal = "";

bool isLoading = false;
String ivaledAlert = "";
String username_login = "";
String password_login = "";

class _LoginState extends State<Login> {
  login(String username, String password) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    bool check = connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;
    if (check == true) {
      try {
        setState(() {
          isLoading = true;
        });
        var url = "";
        Widget widget;
        if (_radioVal == "student") {
          url = "https://safrji.com/api/v1/admins/login-student";
          widget = Home();
        } else {
          url = "https://safrji.com/api/v1/admins/login-teacher";
          widget = HomeTeacher();
        }
        var response = await http.post(
          Uri.parse(url),
          body: jsonEncode({
            "username": username,
            "password": password,
          }),
          headers: {"Content-type": "Application/json;charset=UTF-8"},
        );
        if (response.statusCode == 200) {
          var responseBody = jsonDecode(response.body);
          if (responseBody['status'] == true) {
            setDataAndToken() async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              if (_radioVal == "student") {
                prefs.setString("token", responseBody['student']['api_token']);
                prefs.setInt("id", responseBody['student']['id']);
                prefs.setString("name", responseBody['student']['name']);
                prefs.setInt(
                    "attendance", responseBody['student']['attendance']);
                prefs.setString("year", responseBody['student']['year']);
                prefs.setString("image", responseBody['student']['image']);
                prefs.setString(
                    "username", responseBody['student']['username']);
                prefs.setInt('isLoggedIn', 2);
              } else {
                prefs.setString("token", responseBody['teacher']['api_token']);
                prefs.setInt("id", responseBody['teacher']['id']);
                prefs.setString("name", responseBody['teacher']['name']);
                prefs.setString("subject", responseBody['teacher']['subject']);
                prefs.setString("image", responseBody['teacher']['image']);
                prefs.setString(
                    "username", responseBody['teacher']['username']);
                prefs.setInt('isLoggedIn', 3);
              }

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => widget),
                (Route<dynamic> route) => false,
              );
            }

            setDataAndToken();
          } else {
            setState(() {
              isLoading = false;
              ivaledAlert = "خطأ في اسم المستخدم او كلمة السر";
            });
          }
          return responseBody;
        } else {
          Fluttertoast.showToast(
              msg: "فشل تسجيل الدخول",
              toastLength: Toast.LENGTH_SHORT,
              textColor: Colors.white,
              fontSize: 16,
              backgroundColor: Colors.grey[800]);
        }
      } catch (e) {
        print(e);
      }

      setState(() {
        isLoading = false;
      });
    } else {
      Fluttertoast.showToast(
          msg: "خطأ في الاتصال",
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.white,
          fontSize: 16,
          backgroundColor: Colors.grey[800]);
    }
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    Color existedColor = Colors.grey;
    OutlineInputBorder outlinedInputBorder = new OutlineInputBorder(
        borderRadius: BorderRadius.circular(50 * fem),
        borderSide: BorderSide(color: existedColor, width: 2 * fem));

    TextStyle textStyle = new TextStyle(
      fontSize: 17 * ffem,
      fontWeight: FontWeight.bold,
      color: existedColor,
    );

    return Scaffold(
      body: Container(
        color: Color(0xffF7F8F9),
        padding: EdgeInsets.all(20),
        child: isLoading == true
            ? Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(
                      color: Color(0xff61B1DF),
                    ), //show this if state is loading
                  ],
                ),
              )
            : SingleChildScrollView(
                child: Form(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 60 * fem,
                      ),
                      Image.asset(
                        'assets/images/login_logo.jpg',
                      ),
                      SizedBox(
                        height: 10 * fem,
                      ),
                      Text(
                        "تسجيل الدخول",
                        style: TextStyle(
                            fontSize: 30 * ffem, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10 * fem,
                      ),
                      Text(
                        "برجاء ادخال اسم المستخدم وكلمة السر",
                        style: TextStyle(
                            fontSize: 17 * ffem,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5 * fem,
                      ),
                      Text(
                        ivaledAlert,
                        style: TextStyle(
                          fontSize: 16 * ffem,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(
                        height: 12 * fem,
                      ),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextFormField(
                          //initialValue: initial,
                          //keyboardType: widget.textInputType,
                          //cursorColor: existedColor,
                          style: textStyle,
                          obscureText: false,
                          decoration: InputDecoration(
                            hintText: "اسم المستخدم",
                            errorStyle: TextStyle(
                              fontSize: 16 * ffem,
                              color: Colors.red,
                            ),
                            prefixIcon: Icon(
                              Icons.person,
                              size: 32 * ffem,
                              color: Colors.grey,
                            ),
                            hintStyle: textStyle,
                            contentPadding: EdgeInsets.only(
                                top: 12 * fem,
                                right: 27 * fem,
                                bottom: 12 * fem,
                                left: 12 * fem),
                            disabledBorder: outlinedInputBorder,
                            enabledBorder: outlinedInputBorder,
                            focusedBorder: outlinedInputBorder,
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50 * fem),
                                borderSide:
                                    BorderSide(color: Colors.red, width: 2)),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50 * ffem),
                              borderSide: BorderSide(
                                width: 2 * fem,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            username_login = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              setState(() {
                                existedColor = Colors.red;
                              });
                              return 'برجاء ادخال اسم المستخدم';
                            }
                            /*
                          if (!RegExp(r'^[a-zA-Z0-9_\-=@,\.;]+$').hasMatch(value)) {
                            setState(() {
                              existedColor = Colors.red;
                            });
                            return 'خطأ في اسم المستخدم';
                          }
                          */
                          },
                        ),
                      ),
                      SizedBox(
                        height: 25 * fem,
                      ),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextFormField(
                          //initialValue: initial,
                          //keyboardType: widget.textInputType,
                          //cursorColor: existedColor,
                          style: textStyle,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "كلمة السر",
                            errorStyle: TextStyle(
                              fontSize: 16 * ffem,
                              color: Colors.red,
                            ),
                            prefixIcon: Icon(
                              Icons.lock,
                              size: 30 * ffem,
                              color: Colors.grey,
                            ),
                            hintStyle: textStyle,
                            contentPadding: EdgeInsets.only(
                                top: 12 * fem,
                                right: 27 * fem,
                                bottom: 12 * fem,
                                left: 12 * fem),
                            disabledBorder: outlinedInputBorder,
                            enabledBorder: outlinedInputBorder,
                            focusedBorder: outlinedInputBorder,
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50 * fem),
                                borderSide:
                                    BorderSide(color: Colors.red, width: 2)),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50 * fem),
                              borderSide: BorderSide(
                                width: 2 * fem,
                                color: Colors.green,
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            password_login = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              setState(() {
                                existedColor = Colors.red;
                              });
                              return 'برجاء ادخال كلمة السر';
                            }
                            /*
                          if (!RegExp(r'^[a-zA-Z0-9_\-=@,\.;]+$').hasMatch(value)) {
                            setState(() {
                              existedColor = Colors.red;
                            });
                            return 'خطأ في اسم المستخدم';
                          }
                          */
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10 * fem,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'طالب',
                            style: TextStyle(
                              fontSize: 17 * ffem,
                            ),
                          ),
                          Radio(
                            value: 1,
                            groupValue: _radioSelected,
                            activeColor: Colors.blue,
                            onChanged: (value) {
                              setState(() {
                                _radioSelected = value!;
                                _radioVal = 'student';
                              });
                            },
                          ),
                          Text(
                            'مدرس',
                            style: TextStyle(
                              fontSize: 17 * ffem,
                            ),
                          ),
                          Radio(
                            value: 2,
                            groupValue: _radioSelected,
                            activeColor: Colors.blue,
                            onChanged: (value) {
                              setState(() {
                                _radioSelected = value!;
                                _radioVal = 'teacher';
                              });
                            },
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10 * fem,
                      ),
                      Container(
                        width: double.infinity,
                        height: 40 * fem,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: StadiumBorder(),
                            ),
                            onPressed: () {
                              login(username_login, password_login);
                            },
                            child: Text(
                              "دخول",
                              style: TextStyle(
                                fontSize: 20 * ffem,
                              ),
                            )),
                      ),
                      SizedBox(
                        height: 50 * fem,
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
