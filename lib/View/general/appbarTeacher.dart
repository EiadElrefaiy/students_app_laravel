import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:students_app/View/10-ProfileTeacher/profileTeacher.dart';
import 'package:students_app/View/2-Login/login.dart';
import 'package:students_app/View/4-profile/profile.dart';

var results;

class AppbarTeacher extends AppBar {
  AppbarTeacher({Key? key}) : super(key: key);

  @override
  State<AppbarTeacher> createState() => _AppbarState();
}

class _AppbarState extends State<AppbarTeacher> {
  var token;
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        IconButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: ((context) => ProfileTeacher())));
            },
            icon: Icon(Icons.person)),
        IconButton(
            onPressed: () {
              Logout();
            },
            icon: Icon(Icons.logout)),
      ],
      backgroundColor: Color(0xff61B1DF),
      bottomOpacity: 0.0,
      elevation: 0.0,
    );
  }
}
